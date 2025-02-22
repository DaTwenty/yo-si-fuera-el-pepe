package;

//imports
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSpriteUtil;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import ui.Mobilecontrols;
#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
  
	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	public static var blackPlayerShit:FlxSprite;
	public static var blackPlayerShitMiddle:FlxSprite;
    public static var blackOpponentShit:FlxSprite;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

// Vanilla: //
// week 2: //
	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;
// week 3 //
	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
// week 4 //
	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
// week 5 //
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

// Vs Hex: Weekend Update // 
// Week 1: //
  var unGlitchedBG:FlxSprite;
  var glitcherStage:FlxSprite;
// week 2: //
// the motherfucker //
  var hexBack:FlxSprite;
  var hexFront:FlxSprite;
  var topOverlay:FlxSprite;
  var crowd:FlxSprite;
  var hexSpotlights:FlxTypedGroup<FlxSprite>;
  var spotlight:FlxSprite;
// el follamamis //
  var hexDarkBack:FlxSprite;
  var hexDarkFront:FlxSprite;
  var topDarkOverlay:FlxSprite;
  var darkCrowd:FlxSprite;
  var darkSpotlight:FlxSprite;
  var darkSpotlight2:FlxSprite;
  // var hexDarkSpotlights:FlxTypedGroup<FlxSprite>;
// hola bebota *le roba su informacion genetica* //
  var hexRemixBack:FlxSprite;
  var hexRemixFront:FlxSprite;
  // falopa //
  var hexBack1:FlxSprite;
  var hexBack2:FlxSprite;
  var hexBack3:FlxSprite;
  var hexFront1:FlxSprite;
  var hexFront2:FlxSprite;
  var hexFront3:FlxSprite;
  var spotlight1:FlxSprite;
  var spotlight2:FlxSprite;
  var spotlight3:FlxSprite;
  var crowd1:FlxSprite;
  var crowd2:FlxSprite;
  var crowd3:FlxSprite;

// Hex stuff //
  // Week 1: //
// (Glitcher)
  public static var glitchedBoyfriend:Boyfriend;
  public static var glitchedHex:Character;
 public static var glitched:Bool = false;

// Week 2: //
// (Cooling)
  public static var boyfriendCoolingDark:Boyfriend;
  public static var hexCoolingDark:Character;
  public static var gfCoolingDark:Character;
	public static var dark:Bool = false;

// (Glitcher Remix)
  public static var remixHex:Character;
  public static var remixBoyfriend:Character;

// (LCD)
  public static var boyfriendLCD2:Boyfriend;
  public static var boyfriendLCD3:Boyfriend;
  public static var hexLCD2:Character;
  public static var hexLCD3:Character;
  public static var gfLCD2:Character;
  public static var gfLCD3:Character;

  public static var hexCurWeek:String = '';
  public static var curMod:String = '';
	public var doMoveArrows = false;
	public var bopOn:Int = 2;
  var hitsound:FlxSound;

	var fc:Bool = true;

// week 6 //
	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var judgementCounter:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	#if mobileC
	var mcontrols:Mobilecontrols; 
	#end


	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);

    hitsound = FlxG.sound.load(Paths.sound('hitsound'));

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		switch(SONG.stage)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}

			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}

			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}

			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}

			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}

			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}

			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}

			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}

//  hex stages: //

//  week 1: //

      case 'hexStage':
				{
            defaultCamZoom = 0.9;
            curStage = 'hexStage';
            curMod = 'hex';
            hexCurWeek = 'hextravanganza';
            var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/stageback', 'shared'));
            bg.antialiasing = true;
            bg.scrollFactor.set(0.9, 0.9);
            bg.active = false;
            add(bg);
				}

      case 'hexStageSunset':
        {
            defaultCamZoom = 0.9;
            curStage = 'hexStageSunset';
            curMod = 'hex';
            hexCurWeek = 'hextravanganza';
            var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/sunset/stageback', 'shared'));
            bg.antialiasing = true;
            bg.scrollFactor.set(0.9, 0.9);
            bg.active = false;
            add(bg);
				}

      case 'hexStageNight':
        {
            defaultCamZoom = 0.9;
            curStage = 'hexStageNight';
            curMod = 'hex';
            hexCurWeek = 'hextravanganza';
            var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/night/stageback', 'shared'));
            bg.antialiasing = true;
            bg.scrollFactor.set(0.9, 0.9);
            bg.active = false;
            add(bg);
        }

      case 'hexStageGlitcher':
        {
            defaultCamZoom = 0.9;
            curStage = 'hexStageGlitcher';
            curMod = 'hex';
            hexCurWeek = 'hextravanganza';
            unGlitchedBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/glitcher/stageback', 'shared'));
            unGlitchedBG.antialiasing = true;
            unGlitchedBG.scrollFactor.set(0.9, 0.9);
            unGlitchedBG.active = false;
            unGlitchedBG.alpha = 1;
            add(unGlitchedBG); 

            glitcherStage = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/WIRE/WIREStageBack', 'shared'));
            glitcherStage.antialiasing = true;
            glitcherStage.scrollFactor.set(0.9, 0.9);
            glitcherStage.active = false;
            glitcherStage.alpha = 0;
            add(glitcherStage);

            glitchedBoyfriend = new Boyfriend(770, 450, "bf-glitched");
            glitchedBoyfriend.alpha = 0;

            glitchedHex = new Character(100, 100, "hex-glitched");
            glitchedHex.alpha = 0;
        }

//  week 2: //
  			case 'hexStageWeekend':
				{
					defaultCamZoom = 0.9;
					curStage = 'hexStageWeekend';
          curMod = 'hex';
          hexCurWeek = 'weekend';
					hexBack = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/hexBack', 'shared'));
          hexBack.antialiasing = true;
          hexBack.scrollFactor.set(0.9, 0.9);
          hexBack.setGraphicSize(Std.int(hexBack.width * 1.5));
          add(hexBack);

					hexFront = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/hexFront', 'shared'));
					hexFront.antialiasing = true;
					hexFront.scrollFactor.set(0.9, 0.9);
					hexFront.setGraphicSize(Std.int(hexFront.width * 1.5));
          add(hexFront);

					topOverlay = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/topOverlay', 'shared'));
					topOverlay.antialiasing = true;
					topOverlay.scrollFactor.set(0.9, 0.9);
					topOverlay.setGraphicSize(Std.int(topOverlay.width * 1.5));
          add(topOverlay);

					crowd = new FlxSprite(42, -14);
					crowd.frames = Paths.getSparrowAtlas('hex/weekend/crowd', "shared");
					crowd.antialiasing = true;
					crowd.scrollFactor.set(0.9, 0.9);
					crowd.setGraphicSize(Std.int(crowd.width * 1.5));
					crowd.animation.addByPrefix('bop', 'Symbol 1', 24, false);
          //crowd.animation.play('bop');
         // add(crowd);

          hexSpotlights = new FlxTypedGroup<FlxSprite>();
         add(hexSpotlights);

					for (i in 0...4)
					{
						var spotlight = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/spot' + i, 'shared'));
						spotlight.antialiasing = true;
						spotlight.scrollFactor.set(0.9, 0.9);
						spotlight.setGraphicSize(Std.int(spotlight.width * 1.5));
						spotlight.alpha = 0;
						spotlight.blend = BlendMode.ADD;
            hexSpotlights.add(spotlight);
					}

            hexCoolingDark = new Character(69, -58, 'hex-cooling-dark');
            hexCoolingDark.alpha = 0;

            boyfriendCoolingDark = new Boyfriend(753, 258, 'bf-cooling-dark');
            boyfriendCoolingDark.alpha = 0;

						gfCoolingDark = new Boyfriend(248, -33, 'gf-cooling-dark');
            gfCoolingDark.alpha = 0;

						hexDarkBack = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/breakBack', 'shared'));
						hexDarkBack.antialiasing = true;
						hexDarkBack.scrollFactor.set(0.9, 0.9);
						hexDarkBack.setGraphicSize(Std.int(hexDarkBack.width * 1.5));
            hexDarkBack.alpha = 0;
            add(hexDarkBack);

					  hexDarkFront = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/breakFront', 'shared'));
						hexDarkFront.antialiasing = true;
						hexDarkFront.scrollFactor.set(0.9, 0.9);
						hexDarkFront.setGraphicSize(Std.int(hexDarkFront.width * 1.5));
            hexDarkFront.alpha = 0;
            add(hexDarkFront);

						topDarkOverlay = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/breakOverlay', 'shared'));
						topDarkOverlay.antialiasing = true;
						topDarkOverlay.scrollFactor.set(0.9, 0.9);
						topDarkOverlay.setGraphicSize(Std.int(topDarkOverlay.width * 1.5));
            topDarkOverlay.alpha = 0;
            add(topDarkOverlay);

						darkCrowd = new FlxSprite(42, -14);
						darkCrowd.frames = Paths.getSparrowAtlas('hex/weekend/crowd_dark', 'shared');
						darkCrowd.animation.addByPrefix('bop', 'Symbol 1', 24, false);
						darkCrowd.antialiasing = true;
						darkCrowd.scrollFactor.set(0.9, 0.9);
						darkCrowd.setGraphicSize(Std.int(darkCrowd.width * 1.5));
            darkCrowd.alpha = 0;

						darkSpotlight = new FlxSprite(0, 0).loadGraphic(Paths.image('hex/weekend/breakSpotlight', 'shared'));
							darkSpotlight.antialiasing = true;
							darkSpotlight.scrollFactor.set(0.9, 0.9);
							darkSpotlight.setGraphicSize(Std.int(darkSpotlight.width * 1.5));
              darkSpotlight.alpha = 0;
							darkSpotlight.blend = BlendMode.ADD;

						darkSpotlight2 = new FlxSprite(0, 0).loadGraphic(Paths.image('hex/weekend/breakSpotlight1', 'shared'));
							darkSpotlight2.antialiasing = true;
							darkSpotlight2.scrollFactor.set(0.9, 0.9);
							darkSpotlight2.setGraphicSize(Std.int(darkSpotlight2.width * 1.5));
              darkSpotlight2.alpha = 0;
							darkSpotlight2.blend = BlendMode.ADD;

/*
          hexDarkSpotlights = new FlxTypedGroup<FlxSprite>();
         add(hexDarkSpotlights);

						for (i in 0...2)
						{
							var darkSpotlight = new FlxSprite(0, 0).loadGraphic(Paths.image('hex/weekend/breakSpotlight', 'shared'));
							darkSpotlight.antialiasing = true;
							darkSpotlight.scrollFactor.set(0.9, 0.9);
							darkSpotlight.setGraphicSize(Std.int(darkSpotlight.width * 1.5));
              darkSpotlight.alpha = 0;
							darkSpotlight.blend = BlendMode.ADD;
              hexDarkSpotlights.add(darkSpotlight);
*/
						}

			case 'hexStageDetected':
				{
					defaultCamZoom = 0.9;
					curStage = 'hexStageDetected';
          hexCurWeek = 'weekend';
          curMod = 'hex';
					hexBack = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/detected/hexBack', 'shared'));
					hexBack.antialiasing = true;
					hexBack.scrollFactor.set(0.9, 0.9);
					hexBack.setGraphicSize(Std.int(hexBack.width * 1.5));
          add(hexBack);

					hexFront = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/detected/hexFront', 'shared'));
					hexFront.antialiasing = true;
					hexFront.scrollFactor.set(0.9, 0.9);
					hexFront.setGraphicSize(Std.int(hexFront.width * 1.5));
          add(hexFront);

					topOverlay = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/detected/topOverlay', 'shared'));
					topOverlay.antialiasing = true;
					topOverlay.scrollFactor.set(0.9, 0.9);
					topOverlay.setGraphicSize(Std.int(topOverlay.width * 1.5));
          add(topOverlay);

					crowd = new FlxSprite(42, -14);
					crowd.frames = Paths.getSparrowAtlas('hex/detected/crowd', 'shared');
					crowd.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					crowd.antialiasing = true;
					crowd.scrollFactor.set(0.9, 0.9);
					crowd.setGraphicSize(Std.int(crowd.width * 1.5));
				}

 			case 'hexStageJava':
				{
					defaultCamZoom = 0.9;
					curStage = 'hexStageJava';
          curMod = 'hex';
          hexCurWeek = 'weekend';
					hexBack = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/hexBack_noVis', 'shared'));
          hexBack.antialiasing = true;
          hexBack.scrollFactor.set(0.9, 0.9);
          hexBack.setGraphicSize(Std.int(hexBack.width * 1.5));
          add(hexBack);

					hexFront = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/hexFront', 'shared'));
					hexFront.antialiasing = true;
					hexFront.scrollFactor.set(0.9, 0.9);
					hexFront.setGraphicSize(Std.int(hexFront.width * 1.5));
          add(hexFront);

					topOverlay = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/weekend/topOverlay', 'shared'));
					topOverlay.antialiasing = true;
					topOverlay.scrollFactor.set(0.9, 0.9);
					topOverlay.setGraphicSize(Std.int(topOverlay.width * 1.5));
          add(topOverlay);

					crowd = new FlxSprite(42, -14);
					crowd.frames = Paths.getSparrowAtlas('hex/weekend/crowd', "shared");
					crowd.antialiasing = true;
					crowd.scrollFactor.set(0.9, 0.9);
					crowd.setGraphicSize(Std.int(crowd.width * 1.5));
					crowd.animation.addByPrefix('bop', 'Symbol 1', 24, false);
          //crowd.animation.play('bop');
         // add(crowd);

				}

			case 'hexStageWeekendGlitcher':
				{
					defaultCamZoom = 0.9;
					curStage = 'hexStageWeekendGlitcher';
          curMod = 'hex';
          hexCurWeek = 'weekend';
					hexBack = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/detected/hexBack', 'shared'));
					hexBack.antialiasing = true;
					hexBack.scrollFactor.set(0.9, 0.9);
					hexBack.setGraphicSize(Std.int(hexBack.width * 1.5));
          add(hexBack);

					hexFront = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/detected/hexFront', 'shared'));
					hexFront.antialiasing = true;
					hexFront.scrollFactor.set(0.9, 0.9);
					hexFront.setGraphicSize(Std.int(hexFront.width * 1.5));
          add(hexFront);

					topOverlay = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/detected/topOverlay', 'shared'));
					topOverlay.antialiasing = true;
					topOverlay.scrollFactor.set(0.9, 0.9);
				 topOverlay.setGraphicSize(Std.int(topOverlay.width * 1.5));
         add(topOverlay);

					crowd = new FlxSprite(42, -14);
					crowd.frames = Paths.getSparrowAtlas('hex/glitcherRemix/remixCrowd', "shared");
					crowd.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					crowd.antialiasing = true;
					crowd.scrollFactor.set(0.9, 0.9);
					crowd.setGraphicSize(Std.int(crowd.width * 1.5));

          remixHex = new Character(125, -75, 'hex-glitched-remix');
          remixHex.alpha = 0;

          remixBoyfriend = new Boyfriend(753, 238, 'bf-glitched-remix');
          remixBoyfriend.alpha = 0;

					hexRemixBack = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/glitcherRemix/au_wire_back', 'shared'));
					hexRemixBack.antialiasing = true;
					hexRemixBack.scrollFactor.set(0.9, 0.9);
					hexRemixBack.setGraphicSize(Std.int(hexRemixBack.width * 1.5));
          hexRemixBack.alpha = 0;
          add(hexRemixBack);

					hexRemixFront = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/glitcherRemix/au_wire_front', 'shared'));
					hexRemixFront.antialiasing = true;
					hexRemixFront.scrollFactor.set(0.9, 0.9);
					hexRemixFront.setGraphicSize(Std.int(hexRemixFront.width * 1.5));
          hexRemixFront.alpha = 0;
          add(hexRemixFront);
				}

      case 'hexStageLCD':
        {
					defaultCamZoom = 0.9;
					curStage = 'hexStageLCD';
          curMod = 'hex';
          hexCurWeek = 'weekend';

					hexBack1 = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/lcd/au_lcd_back_1', 'shared'));
					hexBack1.antialiasing = true;
					hexBack1.scrollFactor.set(0.9, 0.9);
					hexBack1.setGraphicSize(Std.int(hexBack1.width * 1.5));
          add(hexBack1);

					spotlight1 = new FlxSprite(42, 44);
					spotlight1.frames = Paths.getSparrowAtlas('hex/lcd/au_lcd_lights_1', 'shared');
					spotlight1.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					spotlight1.antialiasing = true;
					spotlight1.scrollFactor.set(0.9, 0.9);
					spotlight1.setGraphicSize(Std.int(spotlight1.width * 1.5));
          add(spotlight1);

					hexBack2 = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/lcd/au_lcd_back_2', 'shared'));
					hexBack2.antialiasing = true;
					hexBack2.scrollFactor.set(0.9, 0.9);
					hexBack2.setGraphicSize(Std.int(hexBack2.width * 1.5));
          hexBack2.alpha = 0;
          add(hexBack2);

					spotlight2 = new FlxSprite(42, 44);
					spotlight2.frames = Paths.getSparrowAtlas('hex/lcd/au_lcd_lights_2', "shared");
					spotlight2.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					spotlight2.antialiasing = true;
					spotlight2.scrollFactor.set(0.9, 0.9);
					spotlight2.setGraphicSize(Std.int(spotlight2.width * 1.5));
          spotlight2.alpha = 0;
          add(spotlight2);

					hexLCD2 = new Character(69, -58, 'lcdHEX2');
					hexLCD2.alpha = 0;

					boyfriendLCD2 = new Boyfriend(753, 258, 'lcdBF2');
					boyfriendLCD2.alpha = 0;

					gfLCD2 = new Character(248, -33, 'lcdGF2');
					gfLCD2.alpha = 0;

					hexBack3 = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/lcd/au_lcd_back_3', 'shared'));
					hexBack3.antialiasing = true;
					hexBack3.scrollFactor.set(0.9, 0.9);
					hexBack3.setGraphicSize(Std.int(hexBack3.width * 1.5));
					hexBack3.alpha = 0;
          add(hexBack3);

					spotlight3 = new FlxSprite(42, 44);
					spotlight3.frames = Paths.getSparrowAtlas('hex/lcd/au_lcd_lights_3', "shared");
					spotlight3.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					spotlight3.antialiasing = true;
					spotlight3.scrollFactor.set(0.9, 0.9);
					spotlight3.setGraphicSize(Std.int(spotlight2.width * 1.5));
          spotlight3.alpha = 0;
          add(spotlight3);

					hexLCD3 = new Character(69, -58, 'lcdHEX3');
					hexLCD3.alpha = 0;

					boyfriendLCD3 = new Boyfriend(753, 258, 'lcdBF3');
					boyfriendLCD3.alpha = 0;

					gfLCD3 = new Character(248, -33, 'lcdGF3');
					gfLCD3.alpha = 0;

					hexFront1 = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/lcd/au_lcd_front_1', 'shared'));
					hexFront1.antialiasing = true;
					hexFront1.scrollFactor.set(0.9, 0.9);
					hexFront1.setGraphicSize(Std.int(hexFront1.width * 1.5));
          add(hexFront1);

					hexFront2 = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/lcd/au_lcd_front_2', 'shared'));
					hexFront2.antialiasing = true;
					hexFront2.scrollFactor.set(0.9, 0.9);
					hexFront2.setGraphicSize(Std.int(hexFront2.width * 1.5));
          hexFront2.alpha = 0;
          add(hexFront2);

					hexFront3 = new FlxSprite(-24, 24).loadGraphic(Paths.image('hex/lcd/au_lcd_front_3', 'shared'));
					hexFront3.antialiasing = true;
					hexFront3.scrollFactor.set(0.9, 0.9);
					hexFront3.setGraphicSize(Std.int(hexFront3.width * 1.5));
          hexFront3.alpha = 0;
          add(hexFront3);

					crowd1 = new FlxSprite(42, -14);
					crowd1.frames = Paths.getSparrowAtlas('hex/lcd/au_lcd_audience_1', 'shared');
					crowd1.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					crowd1.antialiasing = true;
					crowd1.scrollFactor.set(0.9, 0.9);
					crowd1.setGraphicSize(Std.int(crowd1.width * 1.5));

					crowd2 = new FlxSprite(42, -14);
					crowd2.frames = Paths.getSparrowAtlas('hex/lcd/au_lcd_audience_2', 'shared');
					crowd2.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					crowd2.antialiasing = true;
					crowd2.scrollFactor.set(0.9, 0.9);
					crowd2.setGraphicSize(Std.int(crowd2.width * 1.5));
          crowd2.alpha = 0;

					crowd3 = new FlxSprite(42, -14);
					crowd3.frames = Paths.getSparrowAtlas('hex/lcd/au_lcd_audience_3', 'shared');
					crowd3.animation.addByPrefix('bop', 'Symbol 1', 24, false);
					crowd3.antialiasing = true;
					crowd3.scrollFactor.set(0.9, 0.9);
					crowd3.setGraphicSize(Std.int(crowd3.width * 1.5));
          crowd3.alpha = 0;
        }

			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-sunset':
				gfVersion = 'gf-sunset';
			case 'gf-night':
				gfVersion = 'gf-night';
			case 'gf-glitcher':
				gfVersion = 'gf-glitcher';
      case 'gf-cooling':
        gfVersion = 'gf-cooling';
      case 'gf-cooling-dark':
        gfVersion = 'gf-cooling-dark';
      case 'gf-detected':
        gfVersion = 'gf-detected';
      case 'lcdGF1':
        gfVersion = 'lcdGF1';
      case 'lcdGF2':
        gfVersion = 'lcdGF2';
      case 'lcdGF3':
        gfVersion = 'lcdGF3';
      default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);

	 		case 'hex-unglitched' | 'hex-glitched':
      dad.y += 120;
			dad.x -=10;
			glitchedHex.y += 120;
			glitchedHex.x -= 10;
		}

		if (dad.curCharacter.startsWith("hex"))
			camPos.set(dad.getGraphicMidpoint().x + 145, dad.getGraphicMidpoint().y - 145);

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions){
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				}
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

        case 'hexStageWeekend' | 'hexStageJava' | 'hexStageLCD':
        gf.x = 248;
        gf.y = -33;
        boyfriend.x = 753;
        boyfriend.y = 258;
        dad.x = 69;
        dad.y = -58;

        case 'hexStageDetected' | 'hexStageWeekendGlitcher':
        gf.x = 248;
        gf.y = -33;
        boyfriend.x = 753;
        boyfriend.y = 238;
        dad.x = 125;
        dad.y = -75;
		}

		add(gf);

   if (hexCurWeek == 'weekend')
   {
     gf.setGraphicSize(Std.int(gf.width * 0.75));
     dad.setGraphicSize(Std.int(dad.width * 0.75));
     boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
   }
   else
   {
     gf.setGraphicSize(Std.int(gf.width * 1.00));
     dad.setGraphicSize(Std.int(dad.width * 1.00));
     boyfriend.setGraphicSize(Std.int(boyfriend.width * 1.00));
   }

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

    if (curStage == 'hexStageGlitcher')
      add(gf);
      add(dad);
      add(boyfriend);
      add(glitchedHex);
      add(glitchedBoyfriend);

    if (curStage == 'hexStageWeekend')
    {
      add(gf);
      add(dad);
      add(boyfriend);

     add(gfCoolingDark);
     add(darkSpotlight);
     add(darkSpotlight2);
     add(hexCoolingDark);
     add(boyfriendCoolingDark);

     gfCoolingDark.setGraphicSize(Std.int(gfCoolingDark.width * 0.75));
     hexCoolingDark.setGraphicSize(Std.int(hexCoolingDark.width * 0.75));
     boyfriendCoolingDark.setGraphicSize(Std.int(boyfriendCoolingDark.width * 0.75));

     add(crowd);
     add(darkCrowd);
    }

    if (curStage == 'hexStageJava')
    {
      add(gf);
      add(dad);
      add(boyfriend);
      add(crowd);
    }

    if (curStage == 'hexStageDetected')
    {
     add(gf);
     add(dad);
     add(boyfriend);

     add(crowd);
    }

    if (curStage == 'hexStageWeekendGlitcher')
    {
     add(gf);
     add(dad);
     add(boyfriend);

     add(remixHex);
     add(remixBoyfriend);

     remixHex.setGraphicSize(Std.int(remixHex.width * 0.75));
     remixBoyfriend.setGraphicSize(Std.int(remixBoyfriend.width * 0.75));

     add(crowd);
    }


    if (curStage == 'hexStageLCD')
    {
     bopOn = 2;

     add(gf);
     add(dad);
     add(boyfriend);

     add(gfLCD2);
     add(gfLCD3);
     add(hexLCD2);
     add(hexLCD3);
     add(boyfriendLCD2);
     add(boyfriendLCD3);

     gfLCD2.setGraphicSize(Std.int(gfLCD2.width * 0.75));
     hexLCD2.setGraphicSize(Std.int(hexLCD2.width * 0.75));
     boyfriendLCD2.setGraphicSize(Std.int(boyfriendLCD2.width * 0.75));

     gfLCD3.setGraphicSize(Std.int(gfLCD3.width * 0.75));
     hexLCD3.setGraphicSize(Std.int(hexLCD3.width * 0.75));
     boyfriendLCD3.setGraphicSize(Std.int(boyfriendLCD3.width * 0.75));

    add(crowd1);
    add(crowd2);
    add(crowd3);
    }

		add(dad);
		add(boyfriend);
		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

	if (FlxG.save.data.laneUnderlay){

		blackPlayerShit = new FlxSprite(665, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2, FlxColor.BLACK);
		blackPlayerShit.alpha = 0.6;
		blackPlayerShit.scrollFactor.set();
		add(blackPlayerShit);
	
		if (executeModchart){
			blackPlayerShit.alpha = 0;
		}
	
		blackOpponentShit = new FlxSprite(50, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2, FlxColor.BLACK);
		blackOpponentShit.alpha = 0.6;
		blackOpponentShit.scrollFactor.set();
		add(blackOpponentShit);
	
		if (executeModchart){
			blackOpponentShit.alpha = 0;
		}
		
		if (FlxG.save.data.middle)
		{
			blackPlayerShitMiddle = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2, FlxColor.BLACK);
			blackPlayerShitMiddle.alpha = 0.6;
			blackPlayerShitMiddle.scrollFactor.set();
			blackPlayerShitMiddle.screenCenter();
			add(blackPlayerShitMiddle);
	
			blackPlayerShit.alpha = 0;
			blackOpponentShit.alpha = 0;
	
			if (executeModchart){
				blackPlayerShitMiddle.alpha = 0;
			}
		}		
	}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		if (hexCurWeek == 'weekend' && curStage != 'hexStageLCD')
      camFollow.setPosition(camPos.x, camPos.y + 160);
       else
      camFollow.setPosition(camPos.x, camPos.y);

		if (curStage == "hexStageLCD")
			camFollow.setPosition(camPos.x + 135, camPos.y + 15);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		//if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));

    if (curMod == 'hex')
    healthBarBG.loadGraphic(Paths.image('healthBarHex'));

		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		// healthBar
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
     switch(dad.curCharacter)
    {
    case 'hex' | 'hex-sunset' | 'hex-night' | 'hex-cooling' | 'lcdHEX1':
    healthBar.createFilledBar(0xFF51FFFF, 0xFF3078FF);
    case 'hex-unglitched' | 'hex-glitched':
    healthBar.createFilledBar(0xFFFF1D19, 0xFF3078FF);
    case 'hex-detected':
    healthBar.createFilledBar(0xFFFF1F1D, 0xFF3078FF);
    }

		add(healthBar);
		add(healthBarBG);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4, healthBarBG.y
			+ 50, 0,
			SONG.song
			+ (FlxMath.roundDecimal(songMultiplier, 2) != 1.00 ? " (" + FlxMath.roundDecimal(songMultiplier, 2) + "x)" : "")
			+ " - "
			+ CoolUtil.difficultyFromInt(storyDifficulty),
			16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 25 + 10;
/*
		var creditTxt:FlxText = new FlxText(50, 50, ("KE-HEX v1 (PORT BY TWENTY AND DANYPRO08)"), 20);
		creditTxt.scrollFactor.set();
		creditTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(creditTxt);
*/
        var creditTxt:FlxText = new FlxText(10, 25, ("KE-HEX v2 \nPort by Twenty, Ang3l =) & DanyPro08 \nsexo"), 20);
        creditTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        creditTxt.scrollFactor.set();
        creditTxt.borderSize = 2;
        creditTxt.borderQuality = 2;
        add(creditTxt);

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		scoreTxt.screenCenter(X);
		scoreTxt.scrollFactor.set();
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy);												  
		add(scoreTxt);

		judgementCounter = new FlxText(20, 0, 0, "", 20);
		judgementCounter.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounter.borderSize = 2;
		judgementCounter.borderQuality = 2;
		judgementCounter.scrollFactor.set();
		judgementCounter.cameras = [camHUD];
		judgementCounter.screenCenter(Y);
		judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nporn: ${sicks}';
		if (FlxG.save.data.judgementCounter)
		{
			add(judgementCounter);
		}

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);


	if (FlxG.save.data.middle){
		blackPlayerShitMiddle.cameras = [camHUD];
	}
	if (FlxG.save.data.laneUnderlay){
		blackOpponentShit.cameras = [camHUD];
		blackPlayerShit.cameras = [camHUD];
	}
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
    creditTxt.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		#if mobileC
			mcontrols = new Mobilecontrols();
			switch (mcontrols.mode)
			{
				case VIRTUALPAD_RIGHT | VIRTUALPAD_LEFT | VIRTUALPAD_CUSTOM:
					controls.setVirtualPad(mcontrols._virtualPad, FULL, NONE);
				case HITBOX:
					controls.setHitBox(mcontrols._hitbox);
				default:
			}
			trackedinputs = controls.trackedinputs;
			controls.trackedinputs = [];

			var camcontrol = new FlxCamera();
			FlxG.cameras.add(camcontrol);
			camcontrol.bgColor.alpha = 0;
			mcontrols.cameras = [camcontrol];

			mcontrols.visible = false;

			add(mcontrols);
		#end


		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		// pre lowercasing the song name (schoolIntro)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		if (songLowercase == 'roses' || songLowercase == 'thorns')
		{
			remove(black);

			if (songLowercase == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (songLowercase == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{

		#if mobileC
		mcontrols.visible = true;
		#end
	
		
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');
      if (dark)
      gfCoolingDark.dance();
		  if (gfLCD2 != null && gfLCD3 != null)
		{
			gfLCD2.dance();
			gfLCD3.dance();
		}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	public static var songMultiplier = 1.0;
	var songTime:Float = 0;
	public var bar:FlxSprite;
	var songStarted = false;
	public var previousRate = songMultiplier;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
			songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			songPosBar = new FlxBar(640 - (Std.int(songPosBG.width - 100) / 2), songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 100),
			Std.int(songPosBG.height + 6), this, 'songPositionBar', 0, songLength);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.BLACK, FlxColor.fromRGB(0, 255, 128));
			add(songPosBar);

			bar = new FlxSprite(songPosBar.x, songPosBar.y).makeGraphic(Math.floor(songPosBar.width), Math.floor(songPosBar.height), FlxColor.TRANSPARENT);
			add(bar);

			FlxSpriteUtil.drawRect(bar, 0, 0, songPosBar.width, songPosBar.height, FlxColor.TRANSPARENT, {thickness: 4, color: FlxColor.BLACK});
			songPosBG.width = songPosBar.width;
			songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5), songPosBG.y - 15, 0, SONG.song, 16);
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			//songName.borderSize = 2;
			//songName.borderQuality = 2;
			songName.text = SONG.song;
			songName.y = songPosBG.y + (songPosBG.height / 3);
			add(songName);
			songName.screenCenter(X);

			songPosBG.cameras = [camHUD];
			bar.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				// babyArrow.alpha = 0;
				if (!FlxG.save.data.middle || executeModchart || player == 1)
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					babyArrow.x += 20;
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (FlxG.save.data.middle && !executeModchart)
			{
			    babyArrow.x -= 275;
				if (player != 1)
				{
				    babyArrow.x -= 500;
				} 
			}

			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
	}
}

	private function appearStaticArrows():Void
	{
		strumLineNotes.forEach(function(babyArrow:FlxSprite)
		{
			if (isStoryMode && !FlxG.save.data.middle || executeModchart)
			babyArrow.alpha = 1;

		});
	}
	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.screenCenter(X);

		if (FlxG.keys.justPressed.ENTER  #if android || FlxG.android.justReleased.BACK #end  && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end

       if (hexCurWeek == 'weekend')
       {
				offsetY = -25;
				offsetX = 0;
       }

       if (dark && curStage == 'hexStageWeekend')
       {
        darkSpotlight.x = dad.x - 25;
				darkSpotlight.y = -dad.y - 160;
				FlxTween.tween(darkSpotlight, {alpha: 1}, 0.45);
 				FlxTween.tween(darkSpotlight2, {alpha: 0}, 0.45);
       }

       else if (curStage == 'hexStageWeekend')
       {
       	if (darkSpotlight.alpha != 0)
       {
        FlxTween.tween(darkSpotlight, {alpha: 0}, 0.45);
       }
     }

				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end

       if (hexCurWeek == 'weekend')
       {
				offsetY = 20;
				offsetX = 68;
       }

       if (dark && curStage == 'hexStageWeekend')
       {
        darkSpotlight2.x = boyfriend.x - 24;
				darkSpotlight2.y = -boyfriend.y + 140;
				FlxTween.tween(darkSpotlight2, {alpha: 1}, 0.45);
				FlxTween.tween(darkSpotlight, {alpha: 0}, 0.45);
       }
       else if (curStage == 'hexStageWeekend')
       {
       	if (darkSpotlight2.alpha != 0)
       {
        FlxTween.tween(darkSpotlight2, {alpha: 0}, 0.45);
       }
     }

				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];

				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
				if (!daNote.modifiedByLua)
				{
					if (FlxG.save.data.botplay)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2)) - daNote.noteYOff;
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2)) - daNote.noteYOff;
						if (daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;

							// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
							if (!FlxG.save.data.botplay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
									&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
					else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2)) + daNote.noteYOff;
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
								- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
									2)) + daNote.noteYOff;
						if (daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

							if (!FlxG.save.data.botplay)
							{
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
									&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ Note.swagWidth / 2
										- daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
									+ Note.swagWidth / 2
									- daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
            	// me gusta el sexo gay //
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
                if (glitched)
								glitchedHex.playAnim('singUP' + altAnim, true);
                if (dark)
                hexCoolingDark.playAnim('singUP' + altAnim, true);
                if (remixHex != null)
                remixHex.playAnim('singUP' + altAnim, true);

                if (hexLCD2 != null && hexLCD3 != null)
                {
                hexLCD2.playAnim('singUP' + altAnim, true);
                hexLCD3.playAnim('singUP' + altAnim, true);
                }

							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
								
                if (glitched)
									glitchedHex.playAnim('singRIGHT' + altAnim, true);
                  if (dark)
                  hexCoolingDark.playAnim('singRIGHT' + altAnim, true);
                if (remixHex != null)
                remixHex.playAnim('singRIGHT' + altAnim, true);

                if (hexLCD2 != null && hexLCD3 != null)
                {
                hexLCD2.playAnim('singRIGHT' + altAnim, true);
                hexLCD3.playAnim('singRIGHT' + altAnim, true);
                }

							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
                if (glitched)
								glitchedHex.playAnim('singDOWN' + altAnim, true);
                  if (dark)
                  hexCoolingDark.playAnim('singDOWN' + altAnim, true);
                if (remixHex != null)
                remixHex.playAnim('singDOWN' + altAnim, true);

                if (hexLCD2 != null && hexLCD3 != null)
                {
                hexLCD2.playAnim('singDOWN' + altAnim, true);
                hexLCD3.playAnim('singDOWN' + altAnim, true);
                }

							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
                if (glitched)
								glitchedHex.playAnim('singLEFT' + altAnim, true);
                  if (dark)
                  hexCoolingDark.playAnim('singLEFT' + altAnim, true);
                if (remixHex != null)
                remixHex.playAnim('singLEFT' + altAnim, true);

                if (hexLCD2 != null && hexLCD3 != null)
                {
                hexLCD2.playAnim('singLEFT' + altAnim, true);
                hexLCD3.playAnim('singLEFT' + altAnim, true);
                }
						}

        if (curStage == 'hexStageWeekend' && doMoveArrows)
     {
				var cameraOffsetX = 0;
				var cameraOffsetY = 0;

        switch (daNote.noteData)
        {
        case 2:
        cameraOffsetY = -24;
        case 3:
        cameraOffsetX = 24;
        case 1:
        cameraOffsetY = 24;
        case 0:
        cameraOffsetX = -24;
        }

			camFollow.setPosition((dad.getMidpoint().x + 150) + cameraOffsetX, (dad.getMidpoint().y - 50) + cameraOffsetY);

     }

						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
            if (glitched)
	          glitchedHex.holdTimer = 0;
            if (dark)
            hexCoolingDark.holdTimer = 0;
            if (remixHex != null)
            remixHex.holdTimer = 0;
            if (hexLCD2 != null && hexLCD3 != null)
            {
            hexLCD2.holdTimer = 0;
            hexLCD3.holdTimer = 0;
            }

						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					}	
					
					if (!daNote.mustPress && FlxG.save.data.middle && !executeModchart)
						daNote.alpha = 0;
					if (daNote.isSustainNote)
					{
						daNote.x += daNote.width / 2 + 20;
						if (SONG.noteStyle == 'pixel')
							daNote.x -= 11;
					};
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

			if (FlxG.save.data.cpuStrums)
			{
				cpuStrums.forEach(function(spr:FlxSprite)
				{
					if (spr.animation.finished)
					{
						spr.animation.play('static');
						spr.centerOffsets();
					}
				});
				if(FlxG.save.data.botPlay){
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.animation.finished)
						{
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});
				}
			}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{

		#if mobileC
		mcontrols.visible = false;
		#end

		if (!loadRep)
			trace('hi');
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{

						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					// pre lowercasing the next story song name
					var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
						switch (nextSongLowercase) {
							case 'dad-battle': nextSongLowercase = 'dadbattle';
							case 'philly-nice': nextSongLowercase = 'philly';
						}
					trace(nextSongLowercase + difficulty);

					// pre lowercasing the song name (endSong)
					var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
					switch (songLowercase) {
						case 'dad-battle': songLowercase = 'dadbattle';
						case 'philly-nice': songLowercase = 'philly';
					}
					if (songLowercase == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.2;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;

			if (FlxG.save.data.middle){
				rating.screenCenter();
				rating.updateHitbox();
				rating.acceleration.y = 550;
				rating.y += 90;
				rating.alpha = 0.6;
				rating.x = coolText.x + 265;
				rating.cameras = [camHUD];

				if (executeModchart){
					rating.screenCenter();
					rating.updateHitbox();
					rating.y -= 50;
					rating.x = coolText.x - 125;
					rating.alpha = 5;
					rating.cameras = [camHUD];
				}
			}
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (FlxG.save.data.middle){
					numScore.screenCenter();
					numScore.updateHitbox();
					numScore.acceleration.y = FlxG.random.int(200, 300);
					numScore.x = rating.x + (43 * daLoop) - 50;
				    numScore.y = rating.y + 100;
					numScore.alpha = 0.6;
					numScore.cameras = [camHUD];
					if (executeModchart){
						numScore.screenCenter();
						numScore.x = rating.x + (43 * daLoop) - 50;
						numScore.y = rating.y + 100;
						numScore.alpha = 5;
						numScore.cameras = [camHUD];
					}
				}

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				/*if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				}  */
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;

          if (FlxG.save.data.hitsounds)
          {
          hitsound.play(true);
          }

					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
							if (FlxG.save.data.cpuStrums)
								{
									playerStrums.forEach(function(spr:FlxSprite)
									{
										if (Math.abs(daNote.noteData) == spr.ID)
										{
											spr.animation.play('confirm', true);
										}
										if (spr.animation.curAnim.name == 'confirm' && SONG.noteStyle != 'pixel')
										{
											spr.centerOffsets();
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										}
										else
											spr.centerOffsets();
									});
								}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
          {
						boyfriend.playAnim('idle');
          }
					if (glitched && glitchedBoyfriend.animation.curAnim.name.startsWith('sing') && !glitchedBoyfriend.animation.curAnim.name.endsWith('miss'))
          {
						glitchedBoyfriend.playAnim('idle');
          }

					if (dark && boyfriendCoolingDark.animation.curAnim.name.startsWith('sing') && !boyfriendCoolingDark.animation.curAnim.name.endsWith('miss'))
          {
						boyfriendCoolingDark.playAnim('idle');
          }
 
 					if (remixBoyfriend != null && remixBoyfriend.animation.curAnim.name.startsWith('sing') && !remixBoyfriend.animation.curAnim.name.endsWith('miss'))
          {
						remixBoyfriend.playAnim('idle');
          }
 
  				if (boyfriendLCD2 != null && boyfriendLCD3 != null)
  				{
 					if (boyfriendLCD2.animation.curAnim.name.startsWith('sing') && !boyfriendLCD2.animation.curAnim.name.endsWith('miss'))
						boyfriendLCD2.playAnim('idle');

 					if (boyfriendLCD3.animation.curAnim.name.startsWith('sing') && !boyfriendLCD3.animation.curAnim.name.endsWith('miss'))
						boyfriendLCD3.playAnim('idle');
         }
       }

	   if (!FlxG.save.data.botPlay)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'pressed')
					spr.animation.play('pressed', false);
				if (!holdArray[spr.ID])
					spr.animation.play('static', false);

				if (spr.animation.curAnim.name == 'confirm' && SONG.noteStyle != 'pixel')
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
		}
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
        if (dark)
        gfCoolingDark.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			if(FlxG.save.data.missSounds)
			{
			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			}

//sexo 2
			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
          if (glitched)
					glitchedBoyfriend.playAnim('singLEFTmiss', true);
          if (dark)
          boyfriendCoolingDark.playAnim('singLEFTmiss', true);
          if (remixBoyfriend != null)
          remixBoyfriend.playAnim('singLEFTmiss', true);

          if (boyfriendLCD2 != null && boyfriendLCD3 != null)
          {
          boyfriendLCD2.playAnim('singLEFTmiss', true);
          boyfriendLCD3.playAnim('singLEFTmiss', true);
          }

				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
          if (glitched)
					glitchedBoyfriend.playAnim('singDOWNmiss', true);
          if (dark)
          boyfriendCoolingDark.playAnim('singDOWNmiss', true);
          if (remixBoyfriend != null)
          remixBoyfriend.playAnim('singDOWNmiss', true);

          if (boyfriendLCD2 != null && boyfriendLCD3 != null)
          {
          boyfriendLCD2.playAnim('singDOWNmiss', true);
          boyfriendLCD3.playAnim('singDOWNmiss', true);
          }

				case 2:
					boyfriend.playAnim('singUPmiss', true);
          if (glitched)
				 glitchedBoyfriend.playAnim('singUPmiss', true);
          if (dark)
          boyfriendCoolingDark.playAnim('singUPmiss', true);
          if (remixBoyfriend != null)
          remixBoyfriend.playAnim('singUPmiss', true);

          if (boyfriendLCD2 != null && boyfriendLCD3 != null)
          {
          boyfriendLCD2.playAnim('singUPmiss', true);
          boyfriendLCD3.playAnim('singUPmiss', true);
          }

				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
        if (glitched)
				glitchedBoyfriend.playAnim('singRIGHTmiss', true);
          if (dark)
          boyfriendCoolingDark.playAnim('singRIGHTmiss', true);
          if (remixBoyfriend != null)
          remixBoyfriend.playAnim('singRIGHTmiss', true);

          if (boyfriendLCD2 != null && boyfriendLCD3 != null)
          {
          boyfriendLCD2.playAnim('singRIGHTmiss', true);
          boyfriendLCD3.playAnim('singRIGHTmiss', true);
          }
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);

		scoreTxt.text = Ratings.CalculateRanking(songScore, songScoreDef, nps, maxNPS, accuracy);
		judgementCounter.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nporn: ${sicks}';
	}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	
					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
             if (glitched)
						 glitchedBoyfriend.playAnim('singUP', true);
             if (dark)
             boyfriendCoolingDark.playAnim('singUP', true);
             if (remixBoyfriend != null)
             remixBoyfriend.playAnim('singUP', true);

             if (boyfriendLCD2 != null && boyfriendLCD3 != null)
             {
              boyfriendLCD2.playAnim('singUP', true);
              boyfriendLCD3.playAnim('singUP', true);
             }

						case 3:
							boyfriend.playAnim('singRIGHT', true);
              if (glitched)
							glitchedBoyfriend.playAnim('singRIGHT', true);
             if (dark)
             boyfriendCoolingDark.playAnim('singRIGHT', true);
             if (remixBoyfriend != null)
             remixBoyfriend.playAnim('singRIGHT', true);

             if (boyfriendLCD2 != null && boyfriendLCD3 != null)
             {
              boyfriendLCD2.playAnim('singRIGHT', true);
              boyfriendLCD3.playAnim('singRIGHT', true);
             }

						case 1:
							boyfriend.playAnim('singDOWN', true);
              if (glitched)
						  glitchedBoyfriend.playAnim('singDOWN', true);
             if (dark)
             boyfriendCoolingDark.playAnim('singDOWN', true);
             if (remixBoyfriend != null)
             remixBoyfriend.playAnim('singDOWN', true);

             if (boyfriendLCD2 != null && boyfriendLCD3 != null)
             {
              boyfriendLCD2.playAnim('singDOWN', true);
              boyfriendLCD3.playAnim('singDOWN', true);
             }

						case 0:
							boyfriend.playAnim('singLEFT', true);
              if (glitched)
							glitchedBoyfriend.playAnim('singLEFT', true);
             if (dark)
             boyfriendCoolingDark.playAnim('singLEFT', true);
             if (remixBoyfriend != null)
             remixBoyfriend.playAnim('singLEFT', true);

             if (boyfriendLCD2 != null && boyfriendLCD3 != null)
             {
              boyfriendLCD2.playAnim('singLEFT', true);
              boyfriendLCD3.playAnim('singLEFT', true);
             }
					}


        if (curStage == 'hexStageWeekend' && doMoveArrows)
     {
				var cameraOffsetX = 0;
				var cameraOffsetY = 0;

        switch (note.noteData)
        {
        case 2:
        cameraOffsetY = -24;
        case 3:
        cameraOffsetX = 24;
        case 1:
        cameraOffsetY = 24;
        case 0:
        cameraOffsetX = -24;
        }

				camFollow.setPosition((boyfriend.getMidpoint().x - 192) + cameraOffsetX, (boyfriend.getMidpoint().y - 100) + cameraOffsetY);
     }
	
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					if (!FlxG.save.data.botPlay)
					{
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
					}
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;


	function lcdSwap(type:Int = 0)
	{
		FlxG.camera.flash(FlxColor.WHITE, 0.6);

		switch (type)
		{
			case 0:
				spotlight1.alpha = 1;
				spotlight2.alpha = 0;
				spotlight3.alpha = 0;
				crowd1.alpha = 1;
				crowd2.alpha = 0;
				crowd3.alpha = 0;
				hexBack1.alpha = 1;
				hexBack2.alpha = 0;
				hexBack3.alpha = 0;
				hexFront1.alpha = 1;
				hexFront2.alpha = 0;
				hexFront3.alpha = 0;

				hexLCD2.alpha = 0;
				hexLCD3.alpha = 0;
				boyfriendLCD2.alpha = 0;
				boyfriendLCD3.alpha = 0;
				gfLCD2.alpha = 0;
				gfLCD3.alpha = 0;
				dad.alpha = 1;
				boyfriend.alpha = 1;
				gf.alpha = 1;

			case 1:
				spotlight1.alpha = 0;
				spotlight2.alpha = 1;
				spotlight3.alpha = 0;
				crowd1.alpha = 0;
				crowd2.alpha = 1;
				crowd3.alpha = 0;
				hexBack1.alpha = 0;
				hexBack2.alpha = 1;
				hexBack3.alpha = 0;
				hexFront1.alpha = 0;
				hexFront2.alpha = 1;
				hexFront3.alpha = 0;

				hexLCD2.alpha = 1;
				hexLCD3.alpha = 0;
				boyfriendLCD2.alpha = 1;
				boyfriendLCD3.alpha = 0;
				gfLCD2.alpha = 1;
				gfLCD3.alpha = 0;
				dad.alpha = 0;
				boyfriend.alpha = 0;
				gf.alpha = 0;

			case 2:
				spotlight1.alpha = 0;
				spotlight2.alpha = 0;
				spotlight3.alpha = 1;
				crowd1.alpha = 0;
				crowd2.alpha = 0;
				crowd3.alpha = 1;
				hexBack1.alpha = 0;
				hexBack2.alpha = 0;
				hexBack3.alpha = 1;
				hexFront1.alpha = 0;
				hexFront2.alpha = 0;
				hexFront3.alpha = 1;

				hexLCD2.alpha = 0;
				hexLCD3.alpha = 1;
				boyfriendLCD2.alpha = 0;
				boyfriendLCD3.alpha = 1;
				gfLCD2.alpha = 0;
				gfLCD3.alpha = 1;
				dad.alpha = 0;
				boyfriend.alpha = 0;
				gf.alpha = 0;
		}
	}

	function hexLightsOff(nigga:Bool = true)
	{
    trace("FUCKING NIGGERS I HATE NIGGERS");
		dark = nigga;
		if (nigga)
		{
			FlxTween.tween(hexBack, {alpha: 0}, 0.3);
			FlxTween.tween(hexFront, {alpha: 0}, 0.3);
			FlxTween.tween(topOverlay, {alpha: 0}, 0.3);
			FlxTween.tween(crowd, {alpha: 0}, 0.3);

			FlxTween.tween(hexDarkBack, {alpha: 1}, 0.3);
			FlxTween.tween(hexDarkFront, {alpha: 1}, 0.3);
			FlxTween.tween(topDarkOverlay, {alpha: 1}, 0.3);
			FlxTween.tween(darkCrowd, {alpha: 1}, 0.3);
			FlxTween.tween(hexCoolingDark, {alpha: 1});
			FlxTween.tween(gfCoolingDark, {alpha: 1});
			FlxTween.tween(boyfriendCoolingDark, {alpha: 1});

			FlxTween.tween(dad, {alpha: 0});
			FlxTween.tween(gf, {alpha: 0});
			FlxTween.tween(boyfriend, {alpha: 0});
		}
		else
		{
			FlxTween.tween(hexBack, {alpha: 1}, 0.3);
			FlxTween.tween(hexFront, {alpha: 1}, 0.3);
			FlxTween.tween(topOverlay, {alpha: 1}, 0.3);
			FlxTween.tween(crowd, {alpha: 1}, 0.3);
			FlxTween.tween(hexDarkBack, {alpha: 0}, 0.3);
			FlxTween.tween(hexDarkFront, {alpha: 0}, 0.3);
			FlxTween.tween(topDarkOverlay, {alpha: 0}, 0.3);
			FlxTween.tween(darkCrowd, {alpha: 0}, 0.3);
			FlxTween.tween(hexCoolingDark, {alpha: 0});
			FlxTween.tween(gfCoolingDark, {alpha: 0});
			FlxTween.tween(boyfriendCoolingDark, {alpha: 0});
			FlxTween.tween(dad, {alpha: 1});
			FlxTween.tween(gf, {alpha: 1});
			FlxTween.tween(boyfriend, {alpha: 1});

			if (darkSpotlight2.alpha != 0)
			{
				FlxTween.tween(darkSpotlight2, {alpha: 0}, 0.45);
			}
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end



		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'gf')
				dad.dance();


    if (dark && !hexCoolingDark.animation.curAnim.name.startsWith('sing') && hexCoolingDark.animation.finished)
     hexCoolingDark.dance();

    if (hexLCD2 != null && hexLCD3 != null)
      {
    if (!hexLCD2.animation.curAnim.name.startsWith('sing') && hexLCD2.animation.finished)
      hexLCD2.dance();
    if (!hexLCD3.animation.curAnim.name.startsWith('sing') && hexLCD3.animation.finished)
      hexLCD3.dance();
      }
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

   if (dark && curBeat % gfSpeed == 0)
   {
      gfCoolingDark.dance();
   }

   if (gfLCD2 != null && gfLCD3 != null) 
   {
   if (curBeat % gfSpeed == 0)
    {
      gfLCD2.dance();
      gfLCD3.dance();
    }
   }

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
	
		if (glitched && !glitchedBoyfriend.animation.curAnim.name.startsWith("sing"))
			{
		 glitchedBoyfriend.playAnim('idle');
			}

   if (dark && !boyfriendCoolingDark.animation.curAnim.name.startsWith("sing"))
   {
    boyfriendCoolingDark.playAnim('idle');
   }

   if (remixBoyfriend != null && !remixBoyfriend.animation.curAnim.name.startsWith("sing"))
   {
    remixBoyfriend.playAnim('idle');
   }

   if (boyfriendLCD2 != null && boyfriendLCD3 != null)
   {
    if (!boyfriendLCD2.animation.curAnim.name.startsWith("sing"))
    boyfriendLCD2.playAnim('idle');
    if (!boyfriendLCD3.animation.curAnim.name.startsWith("sing"))
    boyfriendLCD3.playAnim('idle');
   }

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}

   case "hexStageGlitcher":
  if (curBeat == 144 || curBeat == 207 || curBeat == 272 || curBeat == 333)
  {
		glitched = !glitched;
		if (glitched)
		{
// personajes normales //
   FlxTween.tween(dad, {alpha: 0}, 0.15, {ease: FlxEase.linear});
   FlxTween.tween(boyfriend, {alpha: 0}, 0.15, {ease: FlxEase.linear});
   FlxTween.tween(gf, {alpha: 0}, 0.15, {ease: FlxEase.linear});
// personajes glitched //
   FlxTween.tween(glitchedHex, {alpha: 1}, 0.15, {ease: FlxEase.linear});
   FlxTween.tween(glitchedBoyfriend, {alpha: 1}, 0.15, {ease: FlxEase.linear});
// stage //
   FlxTween.tween(glitcherStage, {alpha: 1}, 0.15, {ease: FlxEase.linear});
	 FlxTween.tween(unGlitchedBG, {alpha: 0}, 0.15, {ease: FlxEase.linear});
		}
		else
    {
// personajes normales //
    FlxTween.tween(dad, {alpha: 1}, 0.15, {ease: FlxEase.linear});
    FlxTween.tween(boyfriend, {alpha: 1}, 0.15, {ease: FlxEase.linear});
    FlxTween.tween(gf, {alpha: 1}, 0.15, {ease: FlxEase.linear});
// personajes glitched //
    FlxTween.tween(glitchedHex, {alpha: 0}, 0.15, {ease: FlxEase.linear});
    FlxTween.tween(glitchedBoyfriend, {alpha: 0}, 0.15, {ease: FlxEase.linear});
// stage //
    FlxTween.tween(glitcherStage, {alpha: 0}, 0.15, {ease: FlxEase.linear});
		FlxTween.tween(unGlitchedBG, {alpha: 1}, 0.15, {ease: FlxEase.linear});
     }
   }

     case "hexStageWeekend":
    {
        if (curBeat % bopOn == 0)
        crowd.animation.play('bop', true);
        if (dark)
        darkCrowd.animation.play('bop', true);

       if (curBeat == 68)
			 bopOn = 4;

       if (curBeat == 100)
       bopOn = 2;

       if (curBeat == 132)
       {
       bopOn = 1;
       doMoveArrows = true;
       }

       if (curBeat == 192)
       {
       bopOn = 100;
       doMoveArrows = false;
       }

       if (curBeat == 196)
      {
        bopOn = 4;
        hexLightsOff();
      }
 
       if (curBeat == 228)
        bopOn = 2;
 
       if (curBeat == 256)
      {
       bopOn = 100;
       hexLightsOff(false);
      }

       if (curBeat == 260)
      bopOn = 4;
 
       if (curBeat == 324)
      bopOn = 2;

       if (curBeat == 352)
      bopOn = 100;

       if (curBeat == 356)
     {
      bopOn = 1;
      doMoveArrows = true;
     }

       if (curBeat == 416)
     {
      bopOn = 100;
      doMoveArrows = false;
     }

      if (curBeat == 420)
     {
      bopOn = 4;
     }
    }
  
     case "hexStageWeekendGlitcher":
     {
        if (curBeat % bopOn == 0)
        crowd.animation.play('bop', true);

       switch (curBeat)
        {
        case 144:
					FlxG.camera.flash(FlxColor.RED, 0.6);
					hexRemixBack.alpha = 1;
					hexRemixFront.alpha = 1;
					topOverlay.alpha = 0;
					crowd.alpha = 0;
					hexFront.alpha = 0;
					hexBack.alpha = 0;
					remixHex.alpha = 1;
					remixBoyfriend.alpha = 1;
					dad.alpha = 0;
					boyfriend.alpha = 0;
					gf.alpha = 0;

        case 208:
					FlxG.camera.flash(FlxColor.RED, 0.6);
					hexRemixBack.alpha = 0;
					hexRemixFront.alpha = 0;
					topOverlay.alpha = 1;
					crowd.alpha = 1;
					hexFront.alpha = 1;
					hexBack.alpha = 1;
					remixHex.alpha = 0;
					remixBoyfriend.alpha = 0;
					dad.alpha = 1;
					boyfriend.alpha = 1;
					gf.alpha = 1;

        case 272:
					FlxG.camera.flash(FlxColor.RED, 0.6);
					hexRemixBack.alpha = 1;
					hexRemixFront.alpha = 1;
					topOverlay.alpha = 0;
					crowd.alpha = 0;
					hexFront.alpha = 0;
					hexBack.alpha = 0;
					remixHex.alpha = 1;
					remixBoyfriend.alpha = 1;
					dad.alpha = 0;
					boyfriend.alpha = 0;
					gf.alpha = 0;

        case 336:
					FlxG.camera.flash(FlxColor.RED, 0.6);
					hexRemixBack.alpha = 0;
					hexRemixFront.alpha = 0;
					topOverlay.alpha = 1;
					crowd.alpha = 1;
					hexFront.alpha = 1;
					hexBack.alpha = 1;
					remixHex.alpha = 0;
					remixBoyfriend.alpha = 0;
					dad.alpha = 1;
					boyfriend.alpha = 1;
					gf.alpha = 1;
        }
     }
  
      case "hexStageDetected" | "hexStageJava":
      {
      crowd.animation.play('bop', true);
      }


     case "hexStageLCD":
    {
		 if (curBeat % bopOn == 0)
		  {
			spotlight1.animation.play('bop', true);
			spotlight2.animation.play('bop', true);
			spotlight3.animation.play('bop', true);
			crowd1.animation.play('bop', true);
			crowd2.animation.play('bop', true);
			crowd3.animation.play('bop', true);
		  }

			switch (curBeat)
			{
				case 128:
					bopOn = 1;
					lcdSwap(1);
				case 196:
					bopOn = 4;
					lcdSwap(2);
				case 260:
					bopOn = 2;
					lcdSwap(0);
				case 388:
					bopOn = 1;
					lcdSwap(1);
				case 456:
					bopOn = 2;
					lcdSwap(0);
		  }
    }

			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}

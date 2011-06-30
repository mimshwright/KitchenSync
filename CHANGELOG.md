#KitchenSync lib Change Log

_Visit [KitchenSync on GitHub](http://github.com/mimshwright/KitchenSync) for the latest version_

\* = Contains syntax changes that may require refactoring of legacy code.

##===== v3.0* =====

* **CHANGED -** Package structure.

	* The main package has changed from `org.as3lib.kitchensync` to `ks`. 
	
	* Massively restructured the organization of classes within the packages. 
		
		* `ks.action` package contains all action types in a flat structure. 
		
		* `ks.action` contains tween classes except for tween targets which are in `ks.action.tweentarget`.
		
		* Most support classes have been moved to `ks.core` or `ks.utils`. For example, `KitchenSyncDefaults` and `EasingUtil` are in utils.
		
* **RENAMED -** A couple of tween targets to be more consistent. `TargetProperty` is now `PropertyTweenTarget`. `TimelineController` is now `TimelineTarget`. 

* **REMOVED -** Dependencies on as3lib. Only dependencies now are `abstract-as3.swc` and `ColorMatrix.swc`.

* **MOVED -** Project hosting to [GitHub](http://github.com/mimshwright/KitchenSync).

###===== v2.1* =====

* **ADDED -** Auto-visibility to fade in and out tweens plus a parameter for e.g. automatically setting the alpha to 0 before a fadeIn.

* **ADDED -** `KSRemoveChild` and `KSAddChild`. Just shortcuts for `removeChild()` and `addChild()` but with built-in error checking.

* **ADDED -** `lastActionAdded` to `IActionGroup` which makes it a little easier to tweak anonymous actions when working with groups.

* **ADDED -** `KSProxy` A utility for applying changes from one property to another property. 

* **ADDED -** Optional stage property to `KitchenSync` which can be used internally to get framerate and such. Changed `initialize()` function syntax.

* **ADDED -** progress to `ILoaderActions`.

* **MOVED -** `get progress` to `IAction`.

* **FIXED -** Issues 31, 32, 34, 35 dealing with `KSSequenceGroups` and pausing.

* **FIXED -** Issue when starting a group with no child actions.

* **FIXED -** Possible situation where start event could be dispatched after complete event.

* **CHANGED -** position tween from points to numbers to make it easier to use.

* **CHANGED -** `KSSimpleTween` no longer requires a value for delay. Default is 0.

###===== v2.0.1 =====

* **CHANGED -** No longer requires `KitchenSync.initialize()` ! now auto-initializes.

* **ADDED -** `KSNullAction` - an action that does nothing at all.

* **ADDED -** Advanced scale method to `TweenFactory`

##===== v2.0* =====

Note: Version 2.0 represents a major overhaul to the entire system for greater simplicity and practical functionality. This version will not be backwards compatible. Version 1.x development will continue under a separate branch starting with 1.7.

###USABILITY


* **ADDED -** Better docs to `KitchenSyncEvent` class. 

* **ADDED -** methods in `TweenFactory` and renamed some.

* **REFACTORED -** Constructors throughout the system for more consistency and ease of use.

* **REMOVED -** delay from the `KSFunction` constructor.

* **CHANGED -** all color matrix tweens to use values between -1 and 1.


###SYNCHRONIZER AND TIME


* **REFACTORED -** The way time is handled throughout. The sync mode option is deprecated and will always be active.

* **ADDED -** `ISynchronizerCore` and example core classes. This allows advanced users to switch between different methods of timing (e.g. enterframe or timer based)

* **REMOVED -** `Timestamp` class. From now on, the synchronizer will dispatch an int representing the system time since the SWF initialized. Also removed `TimestampUtil`

* **ADDED -** a method to track the number of active actions.

* **ADDED -** cycles to replace frames in Synchronizer. Every update counts as a cycle.

* **ADDED -** `FrameRateUtil` for getting instantaneous and averaged framerates of the system. The FrameRateView now makes use of this class and has more options.

* **CHANGED -** Using `TimeStringParser_en` to work with frames is now not recommended but a frameRate property has been added to support it. `timeStringParser` is now a property of `KitchenSync` instead of being defined in `AbstractAction`. 


###ACTION ARCHITECTURE


* **MOVED -** some important methods from `AbstractAction`-only to `IAction`.

* **ADDED -** `IPauseable` interface extracted from `IAction`. (wiht intention of making `Synchronizer` use this) 

* **ADDED -** an `IJumpableAction` to specify `jumpToTime` and `jumpByTime` separate from `IAction`.

* **ADDED -** `IPrecisionAction` that defines a method that can start an action at a specific start time. Used in Staggered group

* **ADDED -** `jumpToTime` and `jumpByTime` to `AbstractAction` so (almost) all actions have this functionality.

* **OPTIMIZED -** `startTimeHasElapsed` and `durationHasElapsed` in `AbstractAction`

* **REMOVED -** action triggers from `AbstractAction`. Use `KSSequenceGroups` instead.

* **ADDED -** `togglePause()` method to `AbstractAction`.

* **ADDED -** `progress` variable to `AbstractAction` for getting percentage complete of an action.


###TWEENS


* **ADDED -** methods in `TweenFactory` and renamed some.

* **CHANGED -** constructors in `KSTween`. Emphasis is now on using `TweenFactory`.

* **IMPROVED -** Object parser in `TweenFactory`

* **MOVED -** all tween related classes and tween targets into `org.as3lib.kitchensync.action.tween` package. Got rid of `tweentarget` package.

* **REFACTORED -** `KSTween` clone functions. Some are a little hacky but easy to use. 

* **ADDED -** a method for getting the natural duration of a timeline tweeen in `TimelineController`.

* **ADDED -** `SoundTransformProperties` and refactored `SoundTransformTarget`

* **ADDED -** easing related accessors to `ITween`.

* **ADDED -** `ITweenTargetCollection` for `KSTween`.


###ACTION GROUPS


* **MOVED -** action group related files to `org.as3lib.kitchensync.action.group` package

* **ADDED -** an interface for groups, `IActionGroup`. 

* **ADDED -** Syntactic sugar to the group constructors. using an array in the constructor for a parallel group adds a sequence and vice versa.

* **ADDED -** Looping via a new group called `KSLooper`. 

* **ADDED -** `totalDuration` to groups.

* **ADDED -** `KSRandomGroup`.

* **REMOVED -** `KSSteppedSequenceGroup` because it seemed kinda useless.


###LOADING ACTIONS 


* **REFACTORED -** Now it's much easier to use and more powerful.

* **ADDED -** `KSLoader` for queueing up Loaders for loading SWFs and images

* **ADDED -** `KSLoadQueue` for quickly creating a class to load files from the network in a batch.

* **ADDED -** the `resultList` property to the `ILoaderAction` interface so that you can quickly access the loaded files in a batch.


###RENAMING OF CLASSES


* **RENAMED -** `KitchenSyncEvent` types because of a bug in Flex which makes the wrong event type appear in the auto-complete if the constant name and string don't match.

* **RENAMED -** `KSSoundController` to `KSSound`

* **RENAMED -** `KSAsynchronousFunction` and `KSAsynchronousLoop` to `KSAsyncFunction` and `KSAsyncLoop`

* **RENAMED -** `VALUE\_AT\_START\_OF\_TWEEN` to `AUTO\_TWEEN\_VALUE` and moved it to a global file. Fixed a bug where this wasn't working. Also added this to `KSSimpleTween`.


###BUG FIXES


* **FIXED -** a timing issue in `KSStaggeredGroup`. Now the animations from this group are much smoother.

* **FIXED -** pausing in `KSAsynchronousEvent`

* **FIXED -** some minor bugs


###MISC


* **ADDED -** `KSAsynchronousIteration` for running processor-intensive for loops spaced out over a period of time so that they are essentially asynchronous.

* **REMOVED -** `eventType` and `useWeakReferences` class properties of `KSEventDispatcher`. Modified other methods for garbage collection.

* **REMOVED -** `KSMovieClipController` since it didn't seem to add much and could be confused easily with `TimelineController`.

* **IMPROVED -** `build.xml` to include more targets for building the library. Using SDK 3.4 now.

###===== v1.7 =====

* **ADDED -** [Grant Skinner's ColorMatrix class](http://code.google.com/p/gskinner/downloads/detail?name=ColorMatrixAS3.zip&can=2&q=) for some color tweens

* **ADDED -** Saturation tween target for animating saturation changes (using `ColorMatrix`)

* **ADDED -** Brightness tween target for animating brightness changes (using `ColorMatrix`)

* **ADDED -** Contrast tween target for animating contrast changes (using `ColorMatrix`)

* **ADDED -** `TintTweenTarget` for animating `ColorTransorms`

* **ADDED -** `KSURLLoader` and `KSXMLLoader` for easier load queues

* **CHANGED -** `KSAsyncrhonousFunction` to use strong references
 
###===== v1.6 (2008.10.15) =====

* **ADDED -** TweenFactory which provides an easy to use interface for creating new tweens including an object parser similar to FuseKit's interface.

* **ADDED -** SoundTransformTarget for changing volume or panning of a sound.

* **ADDED -** KSSimultaneousEndGroup which causes all children to end simultaneously.

* **ADDED -** KSSteppedSequenceGroup for sequencing powerpoint-like applications.

* **ADDED -** finished coding INumericController

* **ADDED -** isInstantaneous property to AbstractActions

* **ADDED -** toString() methods to some ITweenTarget classes. Modified toString() for some groups.

* **ADDED -** IAction and ISynchronizerClient interfaces.

* **ADDED -** an optimized implementation of IAction, KSSimpleTween. Saw a 25% performance increase over KSTween!

* **ADDED -** ITween interface

* **CHANGED -** License to MIT license.

* **CHANGED -** all static types that reference AbstractAction to IAction. Now IActions can be added to groups. (needs testing)

* **CHANGED -** Synchronizer to utilize ISynchronizer client. (virtually no performance increase) :-(

* **CHANGED -** Altered KSTween to use multiple tween targets. Now includes methods like addTweenTarget(). some clone methods are deprecated.

* **CHANGED -** KSTween's EXISTING_FROM_VALUE to VALUE_AT_START_OF_TWEEN

* **FIXED -** a bug in KSParallelGroup.stop()

* **FIXED -** a non-bug where using addAction() can cause a null pointer exception after using kill() on a group.

* **REMOVED -** commented out unused 'name' property of AbstractAction

* **UPDATED -** wiki to reflect 1.5 syntax.

###===== v1.5* (2008.07.08) =====

* **REFACTORED -** to optimize performance. Saw an improvement of about 50%

* **ADDED -** TargetProperty and ITweenTarget (formerly ITweenable) to KSTweens (actually, these have been in there for a while, but now they're working)

* **ADDED -** IFilterTweenTarget and implementations for tweening filter properties and simple blurs. 

* **ADDED -** INumericController as a base class for ITweenTarget

* **ADDED -** KSTween.newWithTweenable() and KSTween.cloneWithTweenable() methods for creating tweens with custom tweenables.

* **ADDED -** KSAsynchronousFunction for firing asyncrhonous functions in a sequence. Good for queues.

* **ADDED -** FrameRateView utility which displays the framerate of the Synchronizer.

* **ADDED -** message accessor to KSTrace

* **FIXED -** a bug where children of a group are not cloned when the group is cloned.

* **FIXED -** a bug in KSStaggeredGroup that caused some children not to fire.

* **FIXED -** a bug where actions get fired multiple times in sync mode. (needs verification)

* **MOVED -** snapToWholeValue from KSTween to TargetPropety.

* **RENAMED -** snapToWholeValue to snapToInteger.

* **CHANGED -** KSTween's 'fromValue' and 'toValue' to 'startValue' and 'endValue' and are actually stored in the ITweenTargets.

* **CHANGED -** syntax of KSTween constructor. Now 'startValue' comes before 'endValue'. 

* **CHANGED -** 'util' to 'utils' to match Adobe's and AS3lib's naming conventions.

* **CHANGED -** 'offset' to 'delay' (kept legacy accessors for offset)

* **CHANGED -** KSSoundController now uses the time string parser on the 'soundOffset'.

* **CHANGED -** the core of the Synchronizer to a timer based system thus improving speed.

* **CHANGED -** default policy for 'snapToValueOnComplete' to true which should fix some tween problems.

* **CHANGED -** default frequency for oscillating functions. 

###===== v1.2* (2008.05.2) =====

* **RENAMED -** Nearly the entire library

* **MOVED -** All classes into new packages

* **ADDED -** KitchenSync as the entry point to the library. Use KitchenSync.initialize(this, "1.2"); to start the app.

* **CHANGED -** Synchronizer is no longer used to initialize the library and getInstance() no longer throws an error.

* **FIXED -** A bug in Sequence.kill()

###===== v1.1 (2008.02.22) =====

* **ADDED -** jumpToTime() method to Tween (this may be moved to AbstractSynchronizedAction in a later release)

* **ADDED -** getTimestampFromFrames() and getTimestampFromMilliseconds() to TimestampUtil

* **ADDED -** Timecode to TimeStringParser. Now ":ss", "mm:ss;ff", "dd:hh:mm:ss;ff", etc. are now supported.

* **ADDED -** ActionDefaults class for storing default initialization values.

* **ADDED -** easeOutIn() to most of the easing functions (buggy. seems to overshoot target in some cases)

* **ADDED -** version check in Synchronizer.initialize()

* **CHANGED -** type of Numbers within Timestamp to int.

* **REFACTORED -** all actions to contain super() in the constructor.

* **REMOVED -** errors that are thrown when pause() and start() are called at the wrong times.

####===== v1.0.1 (2008.02.04) ======

* **FIXED -** Cubic.easeOut bug.

* **ADDED -** getters for Tween's toValue and fromValue.

* **ADDED -** source code to main binary.

* **ADDED -** metadata for events.

* **UPDATED -** docs and added summaries to all wiki pages.

##===== v1.0 (2008.01.21) =====

_Note: This is Milestone 1.0 as it is the official release and all basic functionality is complete.)_

* **ADDED -** lots of documentation on the project wiki (http://code.google.com/p/kitchensynclib/w/list)

* **TESTED -** SynchronizedSetProperty and made minor changes.

####===== v0.4.2 (2007.12.20) =====

* **ADDED -** ITimeStringParser. duration and offset now support string values such as "12sec" or "15 frames" or "1h1m2s3ms". See TimeStringParser_en for details

* **CHANGED -** TimeUnit and ActionControllerCommands to be strong-typed enumerations.

* **FIXED -** (partially) bug in Oscillate when dealing with frequencies and different time units.

####===== v0.4.1 (2007.12.13) =====

* **FIXED -** problems with sync property for Tweens

* **MOVED -** project to Google Code (http://kitchensynclib.googlecode.com/)

###===== v0.4 (2007.12.04) =====

* **ADDED -** pause(), unpause(), and stop() to AbstractSynchronizedAction. Also created reset() for Tweens.

* **ADDED -** support for milliseconds or frames using the TimeUnit class. The default time unit is now milliseconds.

* **ADDED -** new AbstractSynchronizedAction type - ActionController - which can tell another action to play, pause, unpause, stop, or kill. 

* **ADDED -** ActionControllerCommands class for holding static constants for each command.

* **ADDED -** SynchronizedGotoFrame for controlling MovieClips (untested)

* **ADDED -** SynchronizedSetProperty (not tested)

* **ADDED -** new class TimestampUtil with add(), subtract() methods.

* **ADDED -** getChildAtIndex() method to AbstractSynchronizedActionGroup.

* **ADDED -** removeTrigger() and removeEventTrigger() to AbstractSynchronizedAction.

* **ADDED -** setTime() to Timestamp

* **ADDED -** minimum and maximum modifiers to Random.ease function.

* **ADDED -** triangle() to Oscillate class.

* **ADDED -** CHILD_START events and moved onChildComplete() and onChildStart() into the AbstractSynchronizedActionGroup class.

* **ADDED -** PAUSE and UNPAUSE events

* **ADDED -** clone() to Timestamp

* **FIXED -** the pesky bug where child actions executed 1 frame late.

* **FIXED -** a bug where Parallel didn't dispatch CHILD_COMPLETE

* **MOVED -** some as3 library files to an externally linked library

* **CHANGED -** start() to return the started action. This will make it easier declare and start in the same line: var tween:Tween = Tween(new Tween(x,y,...).start());

* **CHANGED -** Tween's 'targetProperty' getter and setter to 'value' 

* **CHANGED -** startTimeIsElapsed and durationIsElapsed to public read-only properties.

* **OPTIMIZED -** performance of some functions with sounds and groups.

####===== v0.3.1 (2007.09.28) =====

* **ADDED -** a User's Guide to the docs folder. Docs are available at http://mimswright.com/kitchensync/docs

* **MOVED -** code into a Flex Library Project (and moved demo to a seperate as3 project). Destroyed old repository.

###===== v0.3 (2007.07.07) =====

* **ADDED -** asdoc pages in the /bin/docs folder.

* **ADDED -** autoDelete flag which deletes actions on complete if true

* **ADDED -** addTrigger() and addEventTrigger() to AbstractSyncrhonizedAction so that actions can be triggered by other actions or by events

* **ADDED -** clone() method to most SynchronizedAction classes

* **ADDED -** cloneWithTarget() method to Tween class

* **ADDED -** reverse() and cloneReversed() methods to the Tween class

* **ADDED -** reverseChildOrder() to ActionGroup

* **ADDED -** snapToValueOnComplete and snapToWholeNumber to Tween class

* **ADDED -** documentation to easing functions

* **ADDED -** absoluteSine(), sawtooth(), and pulse() to the Oscillate class

* **ADDED -** Sextic easing class

* **ADDED -** Stepped easing class which produces an easing function that is stepped based on another one.

* **ADDED -** getAveragedFunction() to EasingUtils which produces an average of two types of easing functions.

* **ADDED -** Tween.EXISTING_FROM_VALUE as the from value default. Reordered Tween constructor parameters.

* **REMOVED -** shortcuts for amplitude, period, and overshoot

* **REMOVED -** easeIn(), easeOut(), easeInOut() for Linear and Random

* **MOVED -** Sine.oscillate() to Oscillate.sine()

* **RENAMED -** project to KitchenSync. Moved code to src folder

* **RENAMED -** com.mimswright.animation to com.mimswright.sync

* **OPTIMIZED -** the way that actions listen to synchronizer

* **TESTED -** to ensure the re-usability of action classes

* **TESTED -** and tweaked the SynchronizedSound class

###===== v0.2 (2007.06.21) =====

* **ADDED -** Staggered groups

* **ADDED -** SyncrhonizedSound (not tested)

* **ADDED -** Wait class

* **ADDED -** EasingUtil with call() method for more safely calling easing functions and the generateArray() method for pre-calculating

* **ADDED -** Sine.oscillate() and Random.ease() easing functions

* **ADDED -** easing funcitons. Rewrote all penner v2 easing functions to use fewer arguments and ported to as3

* **ADDED -** ability to set easing function modifiers on a Tween object (includes shortcuts for amplitude, period, and overshoot)

* **ADDED -** ITweenable and TargetProperty classes (aren't implemented yet)

* **FIXED -** a bug with Parallel where items were deleted from array on complete.

* **RENAMED -** SynchronizedEvent to SynchronizedDispatchEvent

##===== v0.1 (2007.06.17) =====

* **ADDED...**

	* Synchronizer                          

	* AbstractSyncrhonizedAction            

	* AbstractSyncrhonizedActionGroup       

	* Sequence and Parallel                 

	* SynchronizedFunction                  

	* SynchronizedTrace                     

	* SynchronizedEvent                     

	* SynchronizerEvent                     

	* Penner's Easing v3 (from alex uhlmann)
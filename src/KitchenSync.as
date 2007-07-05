package {
	import flash.display.Sprite;

	public class KitchenSync extends Sprite
	{
		import flash.events.*;
		import flash.display.*;
		import com.mimswright.easing.*;
		import com.mimswright.sync.*;
		
		public function KitchenSync()
		{	
			stage.frameRate = 30;
			Synchronizer.initialize(this);
						
			// create a sprite for the demo.
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0);
			sprite.graphics.drawRect(0, 0, 10, 10);
			addChild(sprite);	
			
			// create three balls for another demo
			var ball1:Sprite = new Sprite();
			ball1.graphics.beginFill(0);
			ball1.graphics.drawCircle(0, 0, 10);
			addChild(ball1);
			ball1.y = 50;			
			var ball2:Sprite = new Sprite();
			ball2.graphics.beginFill(0);
			ball2.graphics.drawCircle(0, 0, 10);
			addChild(ball2);			
			ball2.y = 100;
			var ball3:Sprite = new Sprite();
			ball3.graphics.beginFill(0);
			ball3.graphics.drawCircle(0, 0, 10);
			addChild(ball3);			
			ball3.y = 150;
			
			
			// demo synchronized sound (you may need to add a sound called song.mp3 to the /bin directory)
			//var sound:Sound = new Sound(new URLRequest("song.mp3"));
			//var song:SynchronizedSound = new SynchronizedSound(sound, 40);
			//var song:SynchronizedSound = new SynchronizedSound("song.mp3", 40);
			//song.start();

			var ballTween:Tween = new Tween(ball1, "x", 400, 0, 30, 0, Average.getAveragedFunction(Cubic.easeInOut, Oscillate.sine));
			var steppedBallTween:Tween = Tween(ballTween.clone());
			steppedBallTween.easingFunction = Stepped.getSteppedFunction(Quadratic.easeInOut, 8);
			
			// demo the Staggered Parallel Group. Each tween is spaced out by 5 frames.
			var ballSequence:Sequence = new Sequence(
				new Staggered(5, 
					ballTween, // demo the tween.cloneWithTarget() method
					ballTween.cloneWithTarget(ball2),
					ballTween.cloneWithTarget(ball3, "x")
				),	
				new Staggered(5, 
					ballTween.cloneReversed(), // demo the cloneReversed() method
					ballTween.cloneReversed(ball2),
					ballTween.cloneReversed(ball3)
				),
				new Staggered(5, 
					steppedBallTween, 
					steppedBallTween.cloneWithTarget(ball2),
					steppedBallTween.cloneWithTarget(ball3)
				),	
				new Staggered(5,
					new Tween(ball1, "alpha", 0, Tween.EXISTING_FROM_VALUE, 30, 0, Linear.ease),
					new Tween(ball2, "alpha", 0, Tween.EXISTING_FROM_VALUE, 30, 0, Linear.ease),
					new Tween(ball3, "alpha", 0, Tween.EXISTING_FROM_VALUE, 30, 0, Linear.ease)
				)
			);
			ballSequence.start();


			// use the EasingUtil.generateArray() if you want to get an array of precalculated values from an 
			// easing function rather than updating each frame.
			trace(EasingUtil.generateArray(Cubic.easeIn, 10));
			
			var sequence:Sequence = new Sequence();
			
			// Test the Oscillate easing functions
			var absSin:Tween = new Tween(sprite, "y", 200, 0, 200, 0, Oscillate.absoluteSine);
			absSin.easingMod1 = 0.03; // frequency in oscillations per unit (frame).
			absSin.snapToValueOnComplete= false;
			
			var sin:Tween = Tween(absSin.clone());
			sin.easingFunction = Oscillate.sine;
			
			var saw:Tween = Tween(absSin.clone());
			saw.easingFunction = Oscillate.sawtooth;
			
			var square:Tween = Tween(absSin.clone());
			square.easingFunction = Oscillate.pulse;
			square.easingMod1 = 0.8;
			
			var pulse:Tween = Tween(square.clone());
			pulse.easingMod2 = 0.8;

			/*
			sequence.addAction(new Parallel(square,new Tween(sprite, "x", 300, 0, absSin.duration, 0, Linear.ease)));
			sequence.addAction(new Parallel(pulse,new Tween(sprite, "x", 300, 0, absSin.duration, 0, Linear.ease)));
			sequence.addAction(new Parallel(saw,new Tween(sprite, "x", 300, 0, absSin.duration, 0, Linear.ease)));
			sequence.addAction(new Parallel(absSin,new Tween(sprite, "x", 300, 0, absSin.duration, 0, Linear.ease)));
			sequence.addAction(new Parallel(sin,new Tween(sprite, "x", 300, 0, absSin.duration, 0, Linear.ease))); 
			*/
			
			// create a new sequence using the constructor to populate with motion tweens
			var demoAll:Sequence = new Sequence( 
			// demo all the motion tweens
				new SynchronizedTrace("Linear"),
				new Tween(sprite, "x", 200, 0, 40, 0, Linear.ease),
			// trace out a message at a given time with SynchronizedTrace
				new SynchronizedTrace("Quadratic"),
				new Tween(sprite, "y", 200, 0, 40, 0, Quadratic.easeInOut),
				new SynchronizedTrace("Cubic"),
				new Tween(sprite, "x", 0, 200, 40, 0, Cubic.easeInOut),
				new SynchronizedTrace("Quartic"),
				new Tween(sprite, "y", 0, 200, 40, 0, Quartic.easeInOut),
				new SynchronizedTrace("Quintic"),
				new Tween(sprite, "x", 200, 0, 40, 0, Quintic.easeInOut),
				new SynchronizedTrace("Sextic"),
				new Tween(sprite, "y", 200, 0, 40, 0, Sextic.easeInOut),
				new SynchronizedTrace("Sine"),
				new Tween(sprite, "x", 0, 200, 40, 0, Sine.easeInOut),
				new SynchronizedTrace("Exponential"),
				new Tween(sprite, "y", 0, 200, 40, 0, Exponential.easeInOut),
				new SynchronizedTrace("Circular"),
				new Tween(sprite, "x", 200, 0, 40, 0, Circular.easeInOut),
				new SynchronizedTrace("Stepped"),
				new Tween(sprite, "y", 200, 0, 80, 0, Stepped.getSteppedFunction(Bounce.easeOut, 15)),
				new Tween(sprite, "x", 0, 200, 40, 0, Stepped.ease),
				new SynchronizedTrace("Random"),
				new Tween(sprite, "y", 0, 200, 40, 0, Random.ease),
				new SynchronizedTrace("Back"),
				new Tween(sprite, "x", 200, 0, 40, 0, Back.easeInOut),
				new SynchronizedTrace("Bounce"),
				new Tween(sprite, "y", 200, 0, 40, 0, Bounce.easeOut),
				new SynchronizedTrace("Elastic"),
				new Tween(sprite, "x", 0, 200, 40, 0, Elastic.easeOut)
			);
			
			sequence.addAction(demoAll);
			
			
			// add a synchronized event that is broadcast after the last motion tween. also add traceEvent as its listener
			sequence.addAction(new SynchronizedDispatchEvent(new SynchronizerEvent("square motion demo complete"), sequence, 0, traceEvent));
			// add more motion, this time using a Parallel object. All children will run simultaneously.
			sequence.addAction(new Parallel(
				new Tween(sprite, "scaleX", 5.0, Tween.EXISTING_FROM_VALUE, 30, 0, Cubic.easeInOut),
				new Tween(sprite, "scaleY", 5.0, Tween.EXISTING_FROM_VALUE, 30, 0, Cubic.easeInOut),
				new Tween(sprite, "rotation", 360, 0, 30, 0, Cubic.easeInOut)
			));
			sequence.addAction(new Parallel(
				new Tween(sprite, "scaleX", 1.0, Tween.EXISTING_FROM_VALUE, 30, 0, Cubic.easeInOut),
				new Tween(sprite, "scaleY", 1.0, Tween.EXISTING_FROM_VALUE, 30, 0, Cubic.easeInOut)
			));
			
			// add another event. this time, only the type is passed in and the event is automatically created
			sequence.addAction(new SynchronizedDispatchEvent("Scaling demo complete", sequence, 0, traceEvent));
			
			// wait 30 frames.
			sequence.addAction(new Wait(30)); 
			
			
			// add the final animation
			sequence.addAction(new Parallel(
				new Tween(sprite, "x", 300, 0, 100, 15, Cubic.easeOut),
				new Tween(sprite, "y", 300, 0, 100, 15, Bounce.easeOut)
			));
			// add a synchronized function which will occur 2 seconds after the last animation.
			var func: SynchronizedFunction = new SynchronizedFunction(60, shoutOut, "EJ", "Roger", "Deepa", "Drew", "Shim");
			// add an event listener that fires when the function is finished running so you can get the results of it
			func.addEventListener(SynchronizerEvent.COMPLETE, onShoutOut);
			sequence.addAction(func);

			// delay the sequence by 2 seconds
			//sequence.offset = 100;
			// adding a listener to the sequence to show when it completes
			sequence.addEventListener(SynchronizerEvent.COMPLETE, onSequenceCompleted);
			// and one for when the sequence's children complete
			sequence.addEventListener(SynchronizerEvent.CHILD_COMPLETE, onChildCompleted);
			// start the whole sequence
			sequence.addTrigger(ballSequence);
			
			// DEBUG
			TargetProperty;
			TweenableFactory;
		}
	
		// traces out the contents of an event object
		public function traceEvent(event:Event):void {
			trace("Received event",event.type,"from",event.target);
		}
		
		public function onSequenceCompleted(event:SynchronizerEvent):void {
			trace(event.target, "completed at frame", event.timestamp.currentFrame);
		}
		public function onChildCompleted(event:SynchronizerEvent):void {
			trace("A Child action completed at frame", event.timestamp.currentFrame);
		}
		
		// takes several peep arguments and returns a shout out to them. 
		// this result will be saved in the SynchronizedFunction's result object.
		public function shoutOut(... peeps):String {
			trace("Running a synched function. You'll have to check the result for a special message.");
			return "Yo big ups to " + peeps.join(", ");
		}
		
		// retrieves the result from the shoutOut function
		public function onShoutOut(event:Event):void {
			var func:SynchronizedFunction = event.target as SynchronizedFunction;
			trace(func.result);
		}
	}
}

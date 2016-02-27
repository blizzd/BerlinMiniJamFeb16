package 
{
import flash.geom.Rectangle;
import flash.utils.setTimeout;

import starling.animation.Transitions;
    import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
    import starling.display.Sprite;
import starling.events.Event;
import starling.events.TouchEvent;
    import starling.events.TouchPhase;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.MathUtil;
import starling.utils.deg2rad;

    /** The Game class represents the actual game. In this scaffold, it just displays a 
     *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
    public class Game extends Sprite
    {
        public static const GAME_OVER:String = "gameOver";
        
        private var mSpaceship:Image;

        private var potatoCount:int = 1;

        private var scoreTextField:TextField;
        private var score:Number = 0;
        
        public function Game()
        {
            init();
        }
        
        private function init():void
        {
            addScore();
            addSpaceShip();
            moveSpaceship();
            addNewPotatoes();
        }

        //SCORE

        private function addScore():void {
            var scoreText:String = "Score: " + score;
            scoreTextField = new TextField(350, 50, scoreText,
                    "Desyrel", BitmapFont.NATIVE_SIZE, 0xffffff);
            scoreTextField.x = (Constants.STAGE_WIDTH - scoreTextField.width) / 2;
            scoreTextField.y = 5;
            addChild(scoreTextField);
        }

        // SPACESHIP

        private function addSpaceShip():void {
            mSpaceship = new Image(Root.assets.getTexture("space-ship"));
            mSpaceship.pivotX = mSpaceship.width / 2;
            mSpaceship.pivotY = mSpaceship.height / 2;
            mSpaceship.x = Constants.STAGE_WIDTH / 2;
            mSpaceship.y = Constants.STAGE_HEIGHT / 2;
            mSpaceship.addEventListener(TouchEvent.TOUCH, onSpaceShipTouched);
            addChild(mSpaceship);
        }

        private function moveSpaceship():void
        {
            var scale:Number = Math.random() * 0.8 + 0.2;
            var endX:Number = Math.random() * (Constants.STAGE_WIDTH - mSpaceship.width);
            var endY:Number = Math.random() * (Constants.STAGE_HEIGHT - mSpaceship.height);


            mSpaceship.addEventListener(Event.ENTER_FRAME, onShipGoingToHit);

            
            Starling.juggler.tween(mSpaceship, Math.random() * 0.5 + 0.5, {
                x: endX,
                y: endY,
                scaleX: scale,
                scaleY: scale,
                rotation: Math.random() * deg2rad(180) - deg2rad(90),
                transition: Transitions.EASE_IN_OUT,
                onComplete: moveSpaceship
            });
        }

        // Spaceship collision detection

        private function onShipGoingToHit(event:Event):void {
            var potatoBeingAboutToGetHit:Image = willShipHitSomething();
            if (potatoBeingAboutToGetHit) {
                if (mSpaceship.getBounds(mSpaceship.root).intersects(potatoBeingAboutToGetHit.getBounds(potatoBeingAboutToGetHit.root))) {
                    Starling.current.stop();
                    setTimeout(doGameOver, 1000);
                }
            }
        }
        
        private function onSpaceShipTouched(event:TouchEvent):void
        {
            if (event.getTouch(mSpaceship, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
                doGameOver();
            }
        }

        private function willShipHitSomething():Image {
            var potatoForTest:Image;
            for (var counter:int = 0; counter < this.numChildren; counter++) {
                if (this.getChildAt(counter).name && this.getChildAt(counter).name.indexOf("potato") != -1) {
                    potatoForTest = this.getChildAt(counter) as Image;
                    if (mSpaceship.getBounds(mSpaceship.root).intersects(potatoForTest.getBounds(potatoForTest.root))) {
                        return potatoForTest;
                    }
                }
            }
            return null;
        }

        // POTATOES

        private function addNewPotatoes():void {
            Starling.juggler.repeatCall(spawnPotato, 5, 0);
        }

        private function spawnPotato():void {
            if (potatoCount % 10 != 0) {
                var mPotato:Image = new Image(Root.assets.getTexture("potato"));
                mPotato.name = "potato" + potatoCount;
                mPotato.pivotX = mPotato.width / 2;
                mPotato.pivotY = mPotato.height / 2;
                mPotato.x = Math.random() * (Constants.STAGE_WIDTH - mPotato.width);
                mPotato.y = Math.random() * (Constants.STAGE_HEIGHT - mPotato.height);
                mPotato.scaleX = 0.5;
                mPotato.scaleY = 0.5;
                mPotato.addEventListener(TouchEvent.TOUCH, onPotatoTouched);
                addChild(mPotato);
                potatoCount++;
                Starling.juggler.repeatCall(rotatePotatoBeing, 0.1, 0, mPotato);
            }else{
                spawnUnitatoBoss();
            }
        }

        private function onPotatoTouched(event:TouchEvent):void {
            if (event.getTouch(event.target as DisplayObject, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
                removeChild(event.target as DisplayObject);
                score +=10;
                scoreTextField.text = "Score: " + score;
            }
        }

        private function rotatePotatoBeing(potatoBeing:Image):void {
            potatoBeing.rotation += MathUtil.normalizeAngle(1);
        }

        // BOSS POTATO

        private function spawnUnitatoBoss():void {
            var mBoss:Image = new Image(Root.assets.getTexture("boss_unitato"));
            mBoss.pivotX = mBoss.width / 2;
            mBoss.pivotY = mBoss.height / 2;
            mBoss.x = Math.random() * (Constants.STAGE_WIDTH - mBoss.width);
            mBoss.y = Math.random() * (Constants.STAGE_HEIGHT - mBoss.height);
            mBoss.scaleX = 0.5;
            mBoss.scaleY = 0.5;
            mBoss.addEventListener(TouchEvent.TOUCH, onBossTouched);
            addChild(mBoss);
            potatoCount++;
            Starling.juggler.repeatCall(rotatePotatoBeing, 0.5, 0, mBoss);
        }

        private function onBossTouched(event:TouchEvent):void {
            if (event.getTouch(event.target as DisplayObject, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
                removeChild(event.target as DisplayObject);
                score +=50;
                scoreTextField.text = "Score: " + score;
            }
        }

        // WHEN YOU FAILED ...

        private function doGameOver():void {
            Starling.juggler.removeTweens(mSpaceship);
            Constants.lastScore = score;
            Starling.juggler.purge();
            dispatchEventWith(GAME_OVER, true, score);
        }
    }
}
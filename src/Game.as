package 
{
    import starling.animation.Transitions;
    import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
    import starling.display.Sprite;
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

        private var potatoCount:int = 0;

        private var scoreTextField:TextField;
        private var score:Number = 0;
        
        public function Game()
        {
            init();
        }
        
        private function init():void
        {
            addScore();
            addBird();
            moveBird();
            addNewPotatoes();
        }

        private function addScore():void {
            var scoreText:String = "Score: " + score;
            scoreTextField = new TextField(350, 50, scoreText,
                    "Desyrel", BitmapFont.NATIVE_SIZE, 0xffffff);
            scoreTextField.x = (Constants.STAGE_WIDTH - scoreTextField.width) / 2;
            scoreTextField.y = 5;
            addChild(scoreTextField);
        }

        private function addBird():void {
            mSpaceship = new Image(Root.assets.getTexture("space-ship"));
            mSpaceship.pivotX = mSpaceship.width / 2;
            mSpaceship.pivotY = mSpaceship.height / 2;
            mSpaceship.x = Constants.STAGE_WIDTH / 2;
            mSpaceship.y = Constants.STAGE_HEIGHT / 2;
            mSpaceship.addEventListener(TouchEvent.TOUCH, onSpaceShipTouched);
            addChild(mSpaceship);
        }
        
        private function moveBird():void
        {
            var scale:Number = Math.random() * 0.8 + 0.2;
            
            Starling.juggler.tween(mSpaceship, Math.random() * 0.5 + 0.5, {
                x: Math.random() * Constants.STAGE_WIDTH,
                y: Math.random() * Constants.STAGE_HEIGHT,
                scaleX: scale,
                scaleY: scale,
                rotation: Math.random() * deg2rad(180) - deg2rad(90),
                transition: Transitions.EASE_IN_OUT,
                onComplete: moveBird
            });
        }
        
        private function onSpaceShipTouched(event:TouchEvent):void
        {
            if (event.getTouch(mSpaceship, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
                Starling.juggler.removeTweens(mSpaceship);
                Constants.lastScore = score;
                dispatchEventWith(GAME_OVER, true, score);
            }
        }

        private function addNewPotatoes():void {
            Starling.juggler.repeatCall(spawnPotato, 5, 0);
        }

        private function spawnPotato():void {
            if (potatoCount<10) {
                var mPotato:Image = new Image(Root.assets.getTexture("potato"));
                mPotato.pivotX = mPotato.width / 2;
                mPotato.pivotY = mPotato.height / 2;
                mPotato.x = Constants.STAGE_WIDTH / 2 + Math.random() * 100;
                mPotato.y = Constants.STAGE_HEIGHT / 2 + Math.random() * 100;
                mPotato.scaleX = 0.5;
                mPotato.scaleY = 0.5;
                mPotato.addEventListener(TouchEvent.TOUCH, onPotatoTouched);
                addChild(mPotato);
                potatoCount++;
                Starling.juggler.repeatCall(rotatePotato, 0.1, 0, mPotato);
            }else{
                potatoCount = 0;
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

        private function rotatePotato(mPotato:Image):void {
            mPotato.rotation += MathUtil.normalizeAngle(1);
        }

        private function spawnUnitatoBoss():void {
            var mBoss:Image = new Image(Root.assets.getTexture("boss_unitato"));
            mBoss.pivotX = mBoss.width / 2;
            mBoss.pivotY = mBoss.height / 2;
            mBoss.x = Constants.STAGE_WIDTH / 2 + Math.random() * 10;
            mBoss.y = Constants.STAGE_HEIGHT / 2 + Math.random() * 10;
            mBoss.scaleX = 0.5;
            mBoss.scaleY = 0.5;
            mBoss.addEventListener(TouchEvent.TOUCH, onBossTouched);
            addChild(mBoss);
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
    }
}
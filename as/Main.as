﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class Main extends MovieClip {
		
		//上限
		private const MAX_ENEMY:int=30;
		private const MAX_HERO_TAMA:int=10;
		//未実装
		//private const MAX_ENEMY_TAMA:int=100;
		
		//スコア系
		private var _score:Number = 0;
		
		//敵が出るタイマー
		private var _timer:Timer;
		
		//インスタンス系
		private var _hero:Hero;
		
		/*注意！！　配列は作り替えないよ*/
		//敵の配列
		private var _enemyList:Array=[];
		//自分の弾丸の配列
		private var _heroTamaList:Array=[];
		
		//敵の弾丸の配列　未実装
		//private var _enemyTamaList:Array=[];
		
		
		/**
		 * コンストラクタ
		 */
		public function Main() {
			
			init();
		}
		
		private function init():void
		{
			this.visible = false;
			
			//インスタンスを先に生成
			for(var i:int=0;i<MAX_ENEMY;i++)
			{
				var enemy:Enemy=new Enemy();
				this.addChild(enemy);
				_enemyList.push(enemy);
			}
			
			
			for(var k:int=0;k<MAX_HERO_TAMA;k++)
			{
				var heroTama:HeroTama=new HeroTama();
				this.addChild(heroTama);
				_heroTamaList.push(heroTama);
			}
			
			
//			for(var j:int=0;j<MAX_ENEMY_TAMA;j++)
//			{
//				var enemyTama:EnemyTama=new EnemyTama();
//				this.addChild(enemyTama);
//				_enemyTamaList.push(enemyTama);
//			}
			
			
		}
		
		/**
		 * ゲーム開始
		 */
		public function start():void
		{
			//この画面を表示
			this.visible = true;
			
			//自分の初期配置
			this._hero = new Hero();
			this._hero.x=Const.WIDTH/2;
			this._hero.y=Const.HEIGHT/2;
			this.addChild(_hero);
			
			
			//タイマー追加
			_timer=new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,_timerHandler);
			_timer.start();
			
			
			//イベント追加
			this.addEventListener(Event.ENTER_FRAME, _step);
			this.addEventListener(MouseEvent.MOUSE_DOWN,_mouseDownHandler);
			
		}
		
		private function _mouseDownHandler(e:MouseEvent):void
		{
			_heroShot(this._hero.x,this._hero.y);
		}
		
		private function _heroShot(myX:Number,myY:Number):void
		{
			for(var i:int=0;i<MAX_HERO_TAMA;i++)
			{
				var heroTama:HeroTama=_heroTamaList[i];
				if(heroTama.isActive==false)
				{
					heroTama.activate(myX,myY);
					break;
				}
	
			}
		}
		
		
		private function _produceEnemy():void
		{
			for(var i:int=0;i<MAX_ENEMY;i++)
			{
				var enemy:Enemy=_enemyList[i];
				if(enemy.isActive==false)
				{
					enemy.activate(Utils.getRandom(Const.WIDTH),Utils.getRandom(Const.HEIGHT));
					break;
				}
				
			}
		}
		

		
		private function _timerHandler(e:TimerEvent):void
		{
			_produceEnemy();
		}
		
		
		private function _step(e:Event):void
		{
			
			//自分の移動
			this._hero.step();
			//自分の弾丸の移動
			_heroTamaList.forEach(__step);
			//羊の移動
			_enemyList.forEach(__step);
			
			//敵の弾丸の移動　未実装！！
			//_enemyTamaList.forEach(__step);
			
			
		
			//弾丸の画面外判定
			_heroTamaList.forEach(__outTest);
		
		}
		
		private function __step(item:IStepItem,index:int, array:Array):void
		{
			item.step();
		}
		
		private function __outTest(item:GameItemSuper,index:int, array:Array):void
		{
			if(item.outTest(Const.WIDTH,Const.HEIGHT))
			{
				item.sleep();
			}
		}
		
		
		
		
		private function _hitTest(objA:MovieClip, objB:MovieClip)
		{
			var bool:Boolean;
			var val1:Number = (objA.x - objB.x) * (objA.x - objB.x) + (objA.y - objB.y) * (objA.y - objB.y);
			var val2:Number = (objA.radius + objB.radius) * (objA.radius + objB.radius);
			
			
			if (val1 <= val2)
			{
				bool=true;
			}
			else
			{
				bool=false;
			}
			
			return bool;
			
		}
		
		
		/**
		 * ゲーム終了
		 */
		public function end():void
		{
			
		}
		
		/**
		 * スコアを返す
		 */
		public function get score():Number
		{
			return _score;
		}
		
	}
	
}

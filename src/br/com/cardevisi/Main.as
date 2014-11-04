package br.com.cardevisi {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Cardevisi
	 */
	public class Main extends Sprite {
		
		private var pathContent:String = "xml/";
		private var xmlFile:String = "data.xml";
		private var btnNext:NextButton;
		private var btnPrev:PrevButton;
		private var marginLeft:int = 1;
		private var slideContainer:Sprite;
		private var containerW:Number;
		private var totalConta:int;
		
		public function Main():void {
			if (stage) init(); 
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			btnNext = new NextButton();
			btnNext.buttonMode = true;
			btnNext.addEventListener(MouseEvent.CLICK, handleClick);
			btnNext.x = stage.stageWidth - btnNext.width;
			btnNext.y = stage.stageHeight * 0.5;
			btnNext.name = "next";
			addChild(btnNext);
			
			btnPrev = new PrevButton();
			btnPrev.buttonMode = true;
			btnPrev.addEventListener(MouseEvent.CLICK, handleClick);
			btnPrev.x = 0;
			btnPrev.y = stage.stageHeight * 0.5;
			btnPrev.name = "prev";
			addChild(btnPrev);
			
			loadData(xmlFile);
		}
		
		private function handleClick(e:MouseEvent):void {
			//totalConta
			var index:int = 0;
			if (e.target.name == "next")  {
				index--;
				
			} else if (e.target.name == "prev")  {
				index++;
			}
			
			scrollingSide(index);
		}
		
		private function scrollingSide(side:int):void {
			var posX:int = (containerW + marginLeft) * side;
			TweenMax.to(slideContainer, 0.5, {x:String(posX), ease:Expo.easeInOut});
		}
		
		private function init(e:Event = null):void {
			var header:Sprite = new Sprite();
				header.graphics.beginFill(0x2b2b2b, 0.5);
				header.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				header.graphics.endFill();
				addChild(header);
				removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function loadData(file:String):void {
			var path:String = pathContent + file;
			var xml_loader:URLLoader = new URLLoader();
				xml_loader.load( new URLRequest(path));
				trace (path);
				xml_loader.addEventListener(Event.COMPLETE, create_gallery);
		}
		
		private function createSlide(data:XML):void  {
			
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0x2b2b2b, 1);
			mask.graphics.drawRect(0, 0, 200, 200) ;
			mask.graphics.endFill();
			
			
			slideContainer = new Sprite();
			addChild(slideContainer);
			
			var container:Sprite;
			var total:int = data.photo.length();
			var txt:TextField;
			
			for (var i:int = 0; i < total; i ++ ) {
				container = createContainer();
				containerW = container.width;
				container.x = (containerW + marginLeft) * i ;
				container.y = 0;
				txt = createTextField(data.photo[i].description);
				container.addChild(txt);
				slideContainer.addChild(container);
			}
			slideContainer.mask =  mask;
		}
		
		private function create_gallery(e:Event):void {
			var xml:XML = new XML(e.target.data);
			createSlide(xml);
		}
		
		private function createTextField(value:String):TextField {
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 15;
			
			var txt:TextField = new TextField();
			txt.defaultTextFormat = txtFormat;
			txt.textColor = 0xFFFFFF;	
			txt.htmlText = value;
			txt.height = 200;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.wordWrap = true;
			return txt;
		}	
		
		private function createContainer():Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x2b2b2b, 1);
			sp.graphics.drawRect(0, 0, 200, 200) ;
			sp.graphics.endFill();
			return sp;
		}
		
	}
	
}
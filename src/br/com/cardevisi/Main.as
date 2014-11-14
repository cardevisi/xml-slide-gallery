package br.com.cardevisi {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import flash.system.LoaderContext;
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
		private var btnNext:Sprite;
		private var btnPrev:Sprite;
		private var marginLeft:int = 1;
		private var slideContainer:Sprite;
		private var mainContainer:Sprite;
		private var containerW:Number;
		private var maskSlide:Sprite;
		private var totalConta:int;
		private var bitmapArray:Array;
		private var bm:Bitmap;
		private var _w:Number = 500;
		private var _h:Number = 500;
		
		public function Main():void {
			if (stage) init(); 
			else addEventListener(Event.ADDED_TO_STAGE, init);
			bitmapArray = new Array() ;
			loadData(xmlFile);
		}
		
		private function handleClick(e:MouseEvent):void {
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
				xml_loader.addEventListener(Event.COMPLETE, createGallery);
		}
		
		private function createSlide(data:XML):void  {
			maskSlide = new Sprite();
			
			mainContainer = new Sprite();
			mainContainer.x = 0;
			mainContainer.y = 0;
			addChild(mainContainer);
			
			slideContainer = new Sprite();
			
			btnNext = createSprite(0, 0, 10, _h, 0xCCCCCC);
			btnNext.buttonMode = true;
			btnNext.addEventListener(MouseEvent.CLICK, handleClick);
			btnNext.x = (_w-btnNext.width);
			btnNext.y = (_h-btnNext.height);
			btnNext.name = "next";
			
			btnPrev = createSprite(0, 0, 10, _h, 0xCCCCCC);
			btnPrev.buttonMode = true;
			btnPrev.addEventListener(MouseEvent.CLICK, handleClick);
			btnPrev.x = 0;
			btnPrev.y = 0;
			btnPrev.name = "prev";
			
			var container:Sprite;
			var total:int = data.photo.length();
			var txt:TextField;
			for (var i:int = 0; i < total; i ++ ) {
				container = createSprite(0, 0, _w, _h, 0x2b2b2b);
				containerW = container.width;
				container.x = (containerW + marginLeft) * i ;
				container.y = 0;
				trace (data.photo[i].filename);
				loadImages(data.photo[i].filename);
				txt = createTextField(data.photo[i].description);
				container.addChild(txt);
				slideContainer.addChild(container);
			}
			
			maskSlide.graphics.beginFill(0x2b2b2b, 1);
			maskSlide.graphics.drawRect(0, 0, _w, _h) ;
			maskSlide.graphics.endFill();
			
			mainContainer.addChild(slideContainer);
			mainContainer.addChild(maskSlide);
			mainContainer.addChild(btnNext);
			mainContainer.addChild(btnPrev);
			
			slideContainer.mask =  maskSlide;
		}
		
		private function createGallery(e:Event):void {
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
			txt.height = _h;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.wordWrap = true;
			return txt;
		}	
		
		private function createSprite(x:Number, y:Number, w:Number, h:Number, color:*):Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(color, 1);
			sp.graphics.drawRect(x, y, w, h);
			sp.graphics.endFill();
			return sp;
		}
		
		private function loadImages(path:String):void {
			var loader:Loader = new Loader();
			var url:URLRequest = new URLRequest(path);
			//var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.load(url);
		}
		
		private function loaderComplete(evt:Event):void {
			var target:Loader = evt.currentTarget.loader as Loader;
			var bmd:BitmapData = new BitmapData(_w, _h);
			var bmp:Bitmap = new Bitmap(bmd);
			trace("BITMAP", bmp);
			//bmp.scaleX = bm.scaleY = .5;
			//bmp.y = bitmapHolder.height;
			//bmd.draw(vid);
			bitmapArray.push(bmp);
			trace(bitmapArray);
		}
		
	}
	
}
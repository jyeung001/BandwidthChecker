package com.yeungus.utils
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	public class Preloader extends EventDispatcher
	{
		private var _mc:MovieClip;
		private var _parentContainer:*;
		private var _loader:Loader;
		private var _bLoader:URLLoader;
		private var _percentLoaded:Number
		private var _contentLoaded:Boolean= false;
		
		//preloader defaults
		private var _originalWidth:Number;

		public function Preloader( parentContainer:*, preloaderMC:MovieClip = null )
		{
			_parentContainer = parentContainer;

			if( preloaderMC != null )
			{
				_mc = preloaderMC;
				_originalWidth = _mc._bar.width;
				_mc._bar.width = 0;
			}
		}
		
		public function get data( ):*
		{
			if( _loader != null && contentLoaded )
				return _loader.content
			else if( _bLoader != null && contentLoaded )
				return _bLoader.data;
			
			return null;
		}
		
		public function get percentLoaded( ):Number
		{
			return _percentLoaded;
		}
		
		public function get contentLoaded( ):Boolean
		{
			return _contentLoaded;
		}
		
		public function load( url:String ):void
		{
			if( url.match( new RegExp( /\.(jpg|gif|png|swf)$/gi ) ).length > 0 )
			{
				_loader = new Loader( );
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onObjectLoaded );
				_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, loadingProgress );
				_loader.load( new URLRequest( url ) );
			}
			else
			{
				_bLoader = new URLLoader( );
				_bLoader.addEventListener( Event.COMPLETE, onObjectLoaded );
				_bLoader.addEventListener( ProgressEvent.PROGRESS, loadingProgress );
				_bLoader.load( new URLRequest( url ) );
			}
		}
		
		private function loadingProgress( e:ProgressEvent ):void
		{
			_percentLoaded = e.bytesLoaded / e.bytesTotal;

			if( _mc != null )
				_mc._bar.width = _originalWidth * percentLoaded;
		}
		
		private function onObjectLoaded( e:Event ):void
		{
			_contentLoaded = true;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
	}
}
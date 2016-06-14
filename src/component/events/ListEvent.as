package com.throne.gui.events{

import com.throne.gui.interfaces.ITListCell;

import flash.events.Event;


public class ListEvent extends Event{
	
	
	public static const ITEM_SELECTED:String = "ITEM_SELECTED";

	
	private var value:*;
	private var cell:ITListCell;
	
	
	public function ListEvent(type:String, value:*, cell:ITListCell){
		super(type);
		this.value = value;
		this.cell = cell;
	}
	
	public function getValue():*{
		return value;
	}
	
	public function getCell():ITListCell{
		return cell;
	}
	
	override public function clone():Event{
		return new ListEvent(type, value, cell);
	}
}
}
package app.components.list
{
	public class GeneralListCellFactory
	{
	
		private var listCellClass:Class;
		private var shareCelles:Boolean;
		private var cacheCells:Boolean;
		
		public function GeneralListCellFactory(listCellClass:Class, shareCelles:Boolean=false, cacheCells:Boolean = true){
			this.listCellClass = listCellClass;
			this.shareCelles = shareCelles;
			this.cacheCells = cacheCells;
		}
		
		public function createNewCell() : AbstractCell {
			return new listCellClass();
		}
		
		public function setIsShareCells(value:Boolean):void{
			shareCelles=value;
		}
		
		public function isShareCells() : Boolean {
			return shareCelles;
		}
		
		public function getCellClass():Class{
			return listCellClass;	
		}
		
		public function isCacheCells():Boolean{
			return cacheCells;
		}
		
		public function setIsCacheCells(value:Boolean):void{
			cacheCells = value;
		}
		
	}
}
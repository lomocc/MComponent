// vars
var widgetRegex = /^mcomponents/;
var allElements = [];
var elements = [];
fl.outputPanel.clear();
var dom = fl.getDocumentDOM();
var layers = fl.getDocumentDOM().getTimeline().layers;
fl.trace("1");
loopLayers(layers, 0);
fl.trace("2");

function loopLayers(layers, currentFrame)
{
	for each(var layer in layers){
		var frames = layer.frames;
		for(var frameIndex in frames){
			var elements = frames[frameIndex].elements;
			for each(var element in elements){
				logElement(element, currentFrame + parseInt(frameIndex));
			}
		}
	}
}

function logElement(element, currentFrame)
{
	if(allElements.indexOf(element) == -1)
	{
		allElements.push(element);
				
		if(element.libraryItem)
		{
			if(widgetRegex.test(element.libraryItem.linkageClassName))
			{
				if(elements.indexOf(element) == -1)
				{
					elements.push(element);
					
					fl.trace(currentFrame + "/" + element.libraryItem.linkageClassName);
				}
			}else if(element.libraryItem.timeline)
			{
				loopLayers(element.libraryItem.timeline.layers, currentFrame);
			}
		}
	}
	//if(element.libraryItem && element.libraryItem.timeline)
	//{
	//	loopLayers(element.libraryItem.timeline.layers);
	//}
	
	
	//libraryItem.timeline
	//fl.trace("-----------------------"+element.libraryItem);
	/*for(var k in element.libraryItem){
		fl.trace(k);
	}*/
}
/*for(var layerIndex in layers){

	var layer = layers[layerIndex];
	var frames = layer.frames;
	for(var frameIndex in frames){
		var frame = frames[frameIndex];
		var elements = frame.elements;
		
		for(var elementIndex in elements){
			var element = elements[elementIndex];
			fl.trace(element.elementType, element.instanceType);
		
		}
	}
	
}*/

/*for each(var layer in layers)
{
    layer.visible=false;
}

for each(var layer in layers)
{
    layer.visible=true;
    traceAll();
    layer.visible=false;
}
for each(var layer in layers)
{
    layer.visible=true;
}*/
/*function traceAll()
{
    dom.selectAll();
    var selection = dom.selection;
	fl.trace(selection.length);
    for each(var element in selection)
    {
        
        if(element == "[object SymbolInstance]")
        {
            dom.selectNone();
            dom.selection=[element];
			if(dom.selection.length>0)
			{
				dom.enterEditMode('inPlace');
				traceAll();
			}
			
			dom.exitEditMode();
        }else if(element.libraryItem && widgetRegex.test(element.libraryItem.linkageClassName)){
			fl.trace(element.libraryItem.linkageClassName);
		}
    }
}*/

/*function traceElement(element)
{
	fl.trace(element);
	if(element == "[object SymbolInstance]")
	{
		dom.selectNone();
		dom.selection=[element];
		dom.enterEditMode('inPlace');
		dom.selectAll();
		var selection = dom.selection;
		fl.trace(selection.length);
		for each(var elementChild in selection)
		{
			traceElement(elementChild);
		}
		dom.exitEditMode();
	}else if(element.libraryItem && widgetRegex.test(element.libraryItem.linkageClassName)){
		fl.trace(element.libraryItem.linkageClassName);
	}
}*/
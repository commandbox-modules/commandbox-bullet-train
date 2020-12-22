component {

	processingdirective pageEncoding='UTF-8';
		
	function configure() {
		
		variables.print = wirebox.getInstance( 'print' );
		
		settings = {
			// General module settings
			'enable' : true,
			'promptChar' : '❯' ,
			'separateLine' : true,
			'addNewLine' : true,
			'unicode' : true,
			// Control the order of the trains.  Removing an item from this list will not make it go away.
			'carOrder' : 'custom,execTime,status,boxVersion,time,dir,package,server,git',
			
			// Execution time car
			'execTimeEnable' : true,
			'execTimeText' : 'black',
			'execTimeBG' : 'yellow',
			// Only show exec time if it's over this many miliseconds
			'execTimeThresholdMS' : 50,
			
			// timestamp car
			'timeEnable' : true,
			'timeText' : 'black',
			'timeBG' : 'white',
			
			// server info car
			'serverEnable' : true,
			'serverText' : 'black',
			'serverBG' : 'white',
			
			// current working directory car
			'dirEnable' : true,
			'dirText' : 'white',
			'dirBG' : 'DodgerBlue1',
			
			// Git repo info car
			'gitEnable' : true,
			'gitText' : 'white',
			'gitCleanBG' : 'green2',
			'gitDirtyBG' : 'red3',
			// Wait this many miliseconds to collect the Git data before giving up
			'gitTimeoutMS' : 200,
			// Override this unicode char if you're not using a Powerline font
			'gitPrefix' : '',
			// Maximum folders to traverse up looking for a .git repo
			'gitDepth' : 0,
			
			// Previous command status car
			'statusEnable' : true,
			'statusText' : 'white',
			'statusFailBG' : 'red',
			'statusSuccessBG' : 'green',
			
			// CommandBox version car
			'boxVersionEnable' : true,
			'boxVersionText' : 'white',
			'boxVersionBG' : 'DodgerBlue3',
			
			// Package info car
			'packageEnable' : true,
			'packageText' : 'white',
			'packageBG' : 'purple3',
			
			// Custom car
			'customEnable' : false,
			'customText' : 'white',
			'customBG' : 'black',
			'customContent' : ' ☢ '
			
		};
		
		interceptorSettings = {
		    customInterceptionPoints = "onBulletTrain"
		};
		
		var files = directoryList( expandPath( modulePath & '/inteceptors' ) );
		
		interceptors = []
		files.each( function( i ) {
			interceptors.append( {
				class : moduleMapping & '.inteceptors.' & i.listLast( '\/' ).listFirst( '.' )
			} );
		} );
		
	}
	
    function prePrompt( interceptData ) {
    	if( settings.unicode ) {
    		var segment_separator='';
    		var thisPromptChar = settings.promptChar;
    	} else {
    		var segment_separator='>';
    		var thisPromptChar = '>';
    	}
    	
    	if( !isBoolean( settings.enable ) || !settings.enable ) {
    		return;
    	}
 
		var interceptorService = wirebox.getInstance( dsl='interceptorService' );
		   	
    	var myData = {
    		settings : settings,
    		cars : {}
    	};
    	interceptorService.announceInterception( 'onBulletTrain', myData );
    	
    	var termWidth = shell.getTermWidth();
    	if( termWidth == 0 ) { termWidth=80; }
    	var currentWidth = 0; 
    	var prompt = ( settings.addNewLine ? chr( 10 ) : '' );
    	currentWidth = 0;
    	var lastbackground = 'black';
    	var first = true;
    	var thisOrder = settings.carOrder.listToArray();
    	myData.cars.each( function( car ) {
    		// Any cars that are present, but not ordered...
    		if( !thisOrder.containsNoCase( car ) ) {
    			// ...get tossed on the end of the order
    			thisOrder.append( car );
    		}
    	} );
    	
    	for( var car in thisOrder ) {
    		car = car.trim();
    		if( !isNull( myData.cars[ car ].text ) ) {
    			// Gather car text in a sperate variable so we can decide if it's short enough to fit on this line
    			var thisCarText = '';
	    		thisCarText &= myData.cars[ car ].text;
	    		thisCarWidth = print.unansi( thisCarText ).len();
	    		
	    		// If this car will overrun the line...
				if( currentWidth + thisCarWidth + 1 > termWidth ) {
					// Print the segment with no background
	    			if( !first ) {
		    			prompt &= print.text( segment_separator, lastbackground );
	    			}
	    			// And add a line break
	    			prompt &= chr( 10 );
	    			// Start the cuumulative acount over
	    			currentWidth = thisCarWidth;
				} else {
					// Otherise, print a transitioning segment
	    			prompt &= print.text( segment_separator, lastbackground & 'on' & myData.cars[ car ].background );
	    			// And add the segment on
					currentWidth += ( thisCarWidth + 1 );
				}
	    		
	    		prompt &= thisCarText;
	    		lastbackground = myData.cars[ car ].background ?: 'black';
	    		first = false;
	    	}
    	}
    	
		prompt &= print.text( segment_separator, lastbackground );
    	
    	interceptData.prompt = prompt & ( settings.separateLine ? chr( 10 ) : '' ) & thisPromptChar &' ';
        
    }
    
}

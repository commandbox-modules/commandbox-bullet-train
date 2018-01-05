component {

	processingdirective pageEncoding='UTF-8';
		
	function configure() {
		
		variables.print = wirebox.getInstance( 'print' );
		
		settings = {
			// General module settings
			'enable' : true,
			'promptChar' : '>' ,
			'separateLine' : true,
			'addNewLine' : true,
			'unicode' : true,
			// Control the order of the trains.  Removing an item from this list will not make it go away.
			'carOrder' : 'execTime,status,time,boxVersion,dir,package,server,git',
			
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
			'dirBG' : 'cyan',
			
			// Git repo info car
			'gitEnable' : true,
			'gitText' : 'white',
			'gitCleanBG' : 'green',
			'gitDirtyBG' : 'red',
			// Wait this many miliseconds to collect the Git data before giving up
			'gitTimeoutMS' : 200,
			// Override this unicode char if you're not using a Powerline font
			'gitPrefix' : '',
			
			// Previous command status car
			'statusEnable' : true,
			'statusText' : 'white',
			'statusFailBG' : 'red',
			'statusSuccessBG' : 'green',
			
			// CommandBox version car
			'boxVersionEnable' : true,
			'boxVersionText' : 'black',
			'boxVersionBG' : 'yellow',
			
			// Package info car
			'packageEnable' : true,
			'packageText' : 'white',
			'packageBG' : 'magenta'
			
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
    	} else {
    		var segment_separator='>';    		
    	}
    	
    	if( !settings.enable ) {
    		return;
    	}
 
		var interceptorService = wirebox.getInstance( dsl='interceptorService' );
		   	
    	var myData = {
    		settings : settings,
    		cars : {}
    	};
    	interceptorService.announceInterception( 'onBulletTrain', myData );
    	
    	var prompt = ( settings.addNewLine ? chr( 10 ) : '' );
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
    			if( !first ) {
	    			prompt &= print.text( segment_separator, lastbackground & 'on' & myData.cars[ car ].background );    				
    			}
	    		prompt &= myData.cars[ car ].text;
	    		lastbackground = myData.cars[ car ].background ?: 'black';
	    		first = false;
	    	}
    	}
    	
		prompt &= print.text( segment_separator, lastbackground );
    	
    	interceptData.prompt = prompt & ( settings.separateLine ? chr( 10 ) : '' ) & settings.promptChar &' ';
        
    }
    
}
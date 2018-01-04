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
			
			// Execution time car
			'execTimeEnable' : true,
			'execTimeText' : 'black',
			'execTimeBG' : 'yellow',
			'execTimeThresholdMS' : 5,
			
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
			'dirBG' : 'blue',
			
			// Git repo info car
			'gitEnable' : true,
			'gitText' : 'white',
			'gitCleanBG' : 'green',
			'gitDirtyBG' : 'red',
			'gitTimeoutMS' : 200,
			
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
			//if( i.listLast( '\/' ).listFirst( '.' ) != 'execTime' ) return; 
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
    	for( var p in myData.cars ) {
    		if( !isNull( myData.cars[ p ].text ) ) {
    			if( !first ) {
	    			prompt &= print.text( segment_separator, lastbackground & 'on' & myData.cars[ p ].background );    				
    			}
	    		prompt &= myData.cars[ p ].text;
	    		lastbackground = myData.cars[ p ].background ?: 'black';
	    		first = false;
	    	}
    	}
    	
		prompt &= print.text( segment_separator, lastbackground );
    	
    	interceptData.prompt = prompt & ( settings.separateLine ? chr( 10 ) : '' ) & settings.promptChar &' ';
        
    }
    
}
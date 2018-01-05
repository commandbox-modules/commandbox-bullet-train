component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function configure() {
		variables.dataCache = {};
		variables.running = {};
	}

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.gitEnable ) { return; }
		
		var CWD = fileSystem.resolvePath( '' );
		// Fire off the data gathering in a thread.  This can take several seconds on a large repo
		var threadName = 'gitBulletTrainCar#createUUID()#'; 
		thread name='#threadName#' timeout=10 CWD='#CWD#' interceptData='#interceptData#' {
			generateData( attributes.CWD, attributes.interceptData );
		}
		
		// Wait up to 200 ms for the thread to finish.
		thread action="join" name='#threadName#' timeout=interceptData.settings.gitTimeoutMS;
		
		// If the thread is still running, we'll use the last cached version, or just output "..." if there's nothing cached.
		interceptData.cars.git = dataCache[ CWD ] ?: { text : print.text( ' ... ', '#interceptData.settings.gitText#on#interceptData.settings.gitDirtyBG#' ), background : interceptData.settings.gitDirtyBG };
			
	}
	
	
	private function generateData( CWD, interceptData ) {
		var repoPath = CWD & '/.git';
		var result = {};
		
		// Short circuit so we don't run more than once for the same dir
		if( running[ CWD ] ?: false ) { return; }
		
		running[ CWD ] = true;
		
		/*
		TODO:
		equals sign for synced
		up arrow for ahead state from remote
		down arrow for behind state from remote
		up/down arrow for diverged state from remote
		*/
		
		try {
	
			if( directoryExists( repoPath ) ) {
				var unicode = interceptData.settings.unicode;
				// Default background color
				var backgroundColor = interceptData.settings.gitCleanBG;
				
				var GitAPI = createObject( 'java', 'org.eclipse.jgit.api.Git' );
				var git = GitAPI.open( createObject( 'java', 'java.io.File' ).init( repoPath ) );
				var branchName = git.getRepository().getBranch();
				
				var statusText = '';
				// User override
				if( interceptData.settings.gitPrefix.len() ) {
					statusText &= '#interceptData.settings.gitPrefix# ';
				} else if( unicode ) {
					statusText &= ' ';
				}
				statusText &= branchName;
				result.text = print.text( ' ' & statusText & ' ... ', '#interceptData.settings.gitText#on#backgroundColor#' );		
				result.background = backgroundColor;
				
				// Store partial results if there's nothing else there
				dataCache[ CWD ] = dataCache[ CWD ] ?: result;
				
				// Now, on to the slower stuff.
				var repoStatus = git.status().call();
				var isClean = repoStatus.isClean();
				var hasAdded = arrayLen( repoStatus.getAdded() );
				var hasConflicting = arrayLen( repoStatus.getConflicting() );
				var hasChanged = arrayLen( repoStatus.getChanged() );
				var hasMissing = arrayLen( repoStatus.getMissing() );
				var hasModified = arrayLen( repoStatus.getModified() );
				var hasRemoved = arrayLen( repoStatus.getRemoved() );
				var hasUnCommittedChanges = arrayLen( repoStatus.getUncommittedChanges() );
				var hasUntracked = arrayLen( repoStatus.getUntracked() );
				var hasUntrackedFolders = arrayLen( repoStatus.getUntrackedFolders() );
				var hasIgnoredNotInIndex = arrayLen( repoStatus.getIgnoredNotInIndex() );
				
		/*		systemoutput( 'isClean: ' & isClean, 1 )
				systemoutput( 'hasAdded: ' & hasAdded, 1 )
				systemoutput( 'hasConflicting: ' & hasConflicting, 1 )
				systemoutput( 'hasChanged: ' & hasChanged, 1 )
				systemoutput( 'hasMissing: ' & hasMissing, 1 )
				systemoutput( 'hasRemoved: ' & hasRemoved, 1 )
				systemoutput( 'hasModified: ' & hasModified, 1 )
				systemoutput( 'hasUnCommittedChanges: ' & hasUnCommittedChanges, 1 )
				systemoutput( 'hasUntracked: ' & hasUntracked, 1 )
				systemoutput( 'hasUntrackedFolders: ' & hasUntrackedFolders, 1 )
				systemoutput( 'hasIgnoredNotInIndex: ' & hasIgnoredNotInIndex, 1 )*/
				
				backgroundColor = isClean ? interceptData.settings.gitCleanBG : interceptData.settings.gitDirtyBG;
				
				// The same file can have a staged modification and also be modified again in the working directory.
				// Get a unique list of modified file names.
				var uniqueModified = {};
				for( var file in repoStatus.getModified().toArray() ) {
					uniqueModified[ file ] = '';
				}
				for( var file in repoStatus.getChanged().toArray() ) {
					uniqueModified[ file ] = '';
				}
				unniqueModifiedCount = uniqueModified.count();
				
				// file added
				if( hasUntracked || hasAdded ) {
					statusText &= ' +#hasUntracked+hasAdded#';
				}				
				// File modified
				if( unniqueModifiedCount ) {
					statusText &= ' ~#unniqueModifiedCount#';
				}				
				// File deleted
				if( hasMissing || hasRemoved ) {
					statusText &= ' -#hasMissing+hasRemoved#';
				}

				result.text = print.text( ' ' & statusText & ' ', '#interceptData.settings.gitText#on#backgroundColor#' );
				result.background = backgroundColor;
			}
		
			dataCache[ CWD ] = result;
			
		} catch( any var e ) {
			result.text = 'Git car: ' & e.message;
			result.background = 'black';
		} finally {
			
			// Release file system locks on the repo
			if( structKeyExists( local, 'git' ) ) {
				git.getRepository().close();
				git.close();
			}
			
			running[ CWD ] = false;
		}
		
	
	}

}
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		var scanner = new presidedataobjects.library.MultipleDirectoryObjectScanner();

		describe( "scanDirectories()", function(){
			it( "should return an empty array when given no directories", function(){
				expect( scanner.scanDirectories( [] ) ).toBe( [] );
			} );
		} );

	}
}
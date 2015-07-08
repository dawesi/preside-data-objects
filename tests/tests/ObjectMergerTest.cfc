component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		var merger = new presidedataobjects.library.ObjectMerger();

		describe( "mergeObjects()", function(){
			it( "should add all methods from objectToMerge to targetObject", function(){
				var targetObject  = new resources.objectmerger.Target();
				var objectToMerge = new resources.objectmerger.ObjectToMerge();

				merger.mergeObjects( targetObject, objectToMerge );

				expect( targetObject.methodOverridden() ).toBe( true );
				expect( targetObject.newMethodSuccessfullyCallingPrivateMethod() ).toBe( true );
			} );

		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/

}

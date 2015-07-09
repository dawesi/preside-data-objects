component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var injector = new presidedataobjects.library.DefaultsInjector();

		describe( "injectDefaultProperties", function(){

			it( "should add an id property when it does not already exist", function(){
				var properties = {};

				injector.injectDefaultProperties( properties=properties );

				expect( properties.id ?: "" ).toBe( { name="id", type="string", dbtype="varchar", maxLength=35, generator="UUID", required=true, pk=true } );
			} );

			it( "should merge any default attributes of the id property when an id property already exists", function(){
				var properties = {
					id = { name="id", type="numeric", dbtype="bigint", generator="increment", maxlength=0, test=true }
				};

				injector.injectDefaultProperties( properties=properties );

				expect( properties.id ?: "" ).toBe( { name="id", type="numeric", dbtype="bigint", maxLength=0, generator="increment", required=true, pk=true, test=true } );
			} );

			it( "should add an datecreated property when it does not already exist", function(){
				var properties = {};

				injector.injectDefaultProperties( properties=properties );

				expect( properties.datecreated ?: "" ).toBe( { name="datecreated", type="date", dbtype="datetime", required=true } );
			} );

			it( "should merge any default attributes of the id property when an id property already exists", function(){
				var properties = {
					datecreated = { name="datecreated", required=false, test=true }
				};

				injector.injectDefaultProperties( properties=properties );

				expect( properties.datecreated ?: "" ).toBe( { name="datecreated", type="date", dbtype="datetime", required=false, test=true } );
			} );

			it( "should add an datemodified property when it does not already exist", function(){
				var properties = {};

				injector.injectDefaultProperties( properties=properties );

				expect( properties.datemodified ?: "" ).toBe( { name="datemodified", type="date", dbtype="datetime", required=true } );
			} );

			it( "should merge any default attributes of the id property when an id property already exists", function(){
				var properties = {
					datemodified = { name="datemodified", required=false, test=true }
				};

				injector.injectDefaultProperties( properties=properties );

				expect( properties.datemodified ?: "" ).toBe( { name="datemodified", type="date", dbtype="datetime", required=false, test=true } );
			} );

		} );
	}

}
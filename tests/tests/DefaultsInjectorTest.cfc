component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var injector = new presidedataobjects.library.DefaultsInjector();

		describe( "injectDefaultProperties()", function(){

			it( "should add an id property when it does not already exist", function(){
				var properties = {};

				injector.injectDefaultProperties( propertyname="testobject", properties=properties );

				expect( properties.id ?: "" ).toBe( { name="id", type="string", dbtype="varchar", maxLength=35, generator="UUID", required=true, pk=true } );
			} );

			it( "should merge any default attributes of the id property when an id property already exists", function(){
				var properties = {
					id = { name="id", type="numeric", dbtype="bigint", generator="increment", maxlength=0, test=true }
				};

				injector.injectDefaultProperties( propertyname="testobject", properties=properties );

				expect( properties.id ?: "" ).toBe( { name="id", type="numeric", dbtype="bigint", maxLength=0, generator="increment", required=true, pk=true, test=true } );
			} );

			it( "should add an datecreated property when it does not already exist", function(){
				var properties = {};

				injector.injectDefaultProperties( propertyname="testobject", properties=properties );

				expect( properties.datecreated ?: "" ).toBe( { name="datecreated", type="date", dbtype="datetime", required=true } );
			} );

			it( "should merge any default attributes of the id property when an id property already exists", function(){
				var properties = {
					datecreated = { name="datecreated", required=false, test=true }
				};

				injector.injectDefaultProperties( propertyname="testobject", properties=properties );

				expect( properties.datecreated ?: "" ).toBe( { name="datecreated", type="date", dbtype="datetime", required=false, test=true } );
			} );

			it( "should add an datemodified property when it does not already exist", function(){
				var properties = {};

				injector.injectDefaultProperties( propertyname="testobject", properties=properties );

				expect( properties.datemodified ?: "" ).toBe( { name="datemodified", type="date", dbtype="datetime", required=true } );
			} );

			it( "should merge any default attributes of the id property when an id property already exists", function(){
				var properties = {
					datemodified = { name="datemodified", required=false, test=true }
				};

				injector.injectDefaultProperties( propertyname="testobject", properties=properties );

				expect( properties.datemodified ?: "" ).toBe( { name="datemodified", type="date", dbtype="datetime", required=false, test=true } );
			} );

		} );

		describe( "injectDefaultPropertyAttributes()", function(){

			it( "should add type=string to fields that do not define a type and that do not define a relationship", function(){
				var prop = { name="label" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.type ?: "" ).toBe( "string" );
			} );

			it( "should set type=string to fields that have type=any", function(){
				var prop = { name="label", type="any" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.type ?: "" ).toBe( "string" );
			} );

			it( "should add dbtype=varchar to string type fields when dbtype not defined", function(){
				var prop = { name="label", type="string" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.dbtype ?: "" ).toBe( "varchar" );
			} );

			it( "should add maxlength=255 to varchar type fields when maxlength not defined", function(){
				var prop = { name="label", type="string" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.maxlength ?: "" ).toBe( 255 );
			} );

			it( "should add dbtype=int to numeric type fields when dbtype not defined", function(){
				var prop = { name="label", type="numeric" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.dbtype ?: "" ).toBe( "int" );
			} );

			it( "should add dbtype=datetime to date type fields when dbtype not defined", function(){
				var prop = { name="label", type="date" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.dbtype ?: "" ).toBe( "datetime" );
			} );

			it( "should add dbtype=boolean to date type fields when dbtype not defined", function(){
				var prop = { name="label", type="boolean" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.dbtype ?: "" ).toBe( "boolean" );
			} );

			it( "should add dbtype=blob to binary type fields when dbtype not defined", function(){
				var prop = { name="label", type="binary" };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.dbtype ?: "" ).toBe( "blob" );
			} );

			it( "should add relatedTo=propname when property defines many-to-one relationship and no relatedTo attribute", function(){
				var prop = { name="someobject", relationship="many-to-one", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.type ?: "" ).toBe( "" );
				expect( prop.relatedTo ?: "" ).toBe( "someobject" );
			} );

			it( "should add relatedTo=propname when property defines many-to-many relationship and no relatedTo attribute", function(){
				var prop = { name="someobject", relationship="many-to-many", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.type ?: "" ).toBe( "" );
				expect( prop.relatedTo ?: "" ).toBe( "someobject" );
			} );

			it( "should add relatedVia attribute when property defines many-to-many relationship and no relatedVia attribute", function(){
				var prop = { name="someobject", relationship="many-to-many", relatedto="anotherobject", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.relatedVia ?: "" ).toBe( "anotherobject__join__testobject" );

				prop = { name="someobject", relationship="many-to-many", relatedto="yet_another_object", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.relatedVia ?: "" ).toBe( "testobject__join__yet_another_object" );
			} );

			it( "should add relationshipIsSource=true when property defines many-to-many relationship and no relationshipIsSource attribute", function(){
				var prop = { name="someobject", relationship="many-to-many", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.relationshipIsSource ?: "" ).toBe( true );
			} );

			it( "should add relatedViaSourceFk=objectname when property defines many-to-many relationship and no relatedViaSourceFk attribute", function(){
				var prop = { name="someobject", relationship="many-to-many", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.relatedViaSourceFk ?: "" ).toBe( "testobject" );
			} );

			it( "should add relatedViaTargetFk=relatedToObjectName when property defines many-to-many relationship and no relatedViaSourceFk attribute", function(){
				var prop = { name="someobject", relationship="many-to-many", required=true  };

				injector.injectDefaultPropertyAttributes( property=prop, objectName="testobject" );

				expect( prop.relatedViaTargetFk ?: "" ).toBe( "someobject" );
			} );

		} );

		describe( "injectDefaultAttributes()", function(){

			it( "should inject tablePrefix=pobj_ when it does not already exist", function(){
				var attribs = {};

				injector.injectDefaultAttributes( attributes=attribs, objectName="testobject" );

				expect( attribs.tablePrefix ?: "" ).toBe( "pobj_" );
			} );

			it( "should leave tablePrefix alone when already does exist", function(){
				var attribs = { tableprefix="test_" };

				injector.injectDefaultAttributes( attributes=attribs, objectName="testobject" );

				expect( attribs.tablePrefix ?: "" ).toBe( "test_" );
			} );

			it( "should inject tableName=objectName when it does not already exist", function(){
				var attribs = {};

				injector.injectDefaultAttributes( attributes=attribs, objectName="testobject" );

				expect( attribs.tableName ?: "" ).toBe( "testobject" );
			} );

			it( "should leave tableName alone when already does exist", function(){
				var attribs = { tableName="test" };

				injector.injectDefaultAttributes( attributes=attribs, objectName="testobject" );

				expect( attribs.tableName ?: "" ).toBe( "test" );
			} );

		} );
	}

}
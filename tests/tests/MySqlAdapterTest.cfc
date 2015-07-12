component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var adapter = new presidedataobjects.db.adapter.MySqlAdapter();

		describe( "escapeEntity()", function(){

			it( "should wrap incoming string with backticks", function(){
				expect( adapter.escapeEntity( "test" ) ).toBe( "`test`" );
			} );

			it( "should escape each part of dot delimited entity", function(){
				expect( adapter.escapeEntity( "test.entity" ) ).toBe( "`test`.`entity`" );
			} );

		} );

		describe( "getColumnDefinitionSql()", function(){

			it( "should return basic column definition in MYSQL format", function(){
				var expected = "`mycolumn` varchar(200) null";
				var result   = adapter.getColumnDefinitionSql(
					  columnName = "mycolumn"
					, dbType     = "varchar"
					, maxLength  = 200
					, nullable   = true
				);

				expect( result ).toBe( expected );
			} );

			it( "should define varchar with 200 length when zero length is specified", function(){
				var expected = "`varchar_column` varchar(200) null";
				var result   = adapter.getColumnDefinitionSql(
					  columnName = "varchar_column"
					, dbType     = "varchar"
					, maxLength  = 0
				);

				expect( result ).toBe( expected );
			} );

			it( "should return column definition with not null and no max size bounds", function(){
				var expected = "`mycolumn` int not null";
				var result   = adapter.getColumnDefinitionSql(
					  columnName = "mycolumn"
					, dbType     = "int"
					, nullable   = false
				);

				expect( result ).toBe( expected );
			} );

			it( "should return well formatted primary key", function(){
				var expected = "`id` varchar(35) not null primary key";
				var result   = adapter.getColumnDefinitionSql(
					  columnName   = "id"
					, dbType       = "varchar"
					, maxLength    = 35
					, nullable     = true
					, primaryKey   = true
				);

				expect( result ).toBe( expected );
			} );

			it( "should return well formatted auto incrementing primary key", function(){
				var expected = "`id` int not null auto_increment primary key";
				var result   = adapter.getColumnDefinitionSql(
					  columnName    = "id"
					, dbType        = "int"
					, nullable      = true
					, primaryKey    = true
					, autoIncrement = true
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getTableDefinitionSql()", function(){

			it( "should return well formed create table statement", function(){
				var expected = "create table `some_table` ( `field1` int not null auto_increment primary key, `field2` bit null, `field3` varchar(30) null ) ENGINE=InnoDB";
				var result  = adapter.getTableDefinitionSql(
					  tableName="some_table"
					, columnSql = "`field1` int not null auto_increment primary key, `field2` bit null, `field3` varchar(30) null"
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getForeignKeyConstraintSql()", function(){

			it( "should return well fommated sql with default onDelete and OnUpdate rules", function(){
				var expected = "alter table `source_table` add constraint `fk_name` foreign key ( `source_col` ) references `foreign_table` ( `foreign_col` ) on delete set null on update cascade";
				var result   = adapter.getForeignKeyConstraintSql(
					  sourceTable    = "source_table"
					, sourceColumn   = "source_col"
					, constraintName = "fk_name"
					, foreignTable   = "foreign_table"
					, foreignColumn  = "foreign_col"
				);

				expect( result ).toBe( expected );
			} );

			it( "should return well formatted sql with passed on onDelete and onUpdate rules", function(){
				var expected = "alter table `source_table` add constraint `fk_name` foreign key ( `source_col` ) references `foreign_table` ( `foreign_col` ) on delete cascade on update set null";
				var result   = adapter.getForeignKeyConstraintSql(
					  sourceTable    = "source_table"
					, sourceColumn   = "source_col"
					, constraintName = "fk_name"
					, foreignTable   = "foreign_table"
					, foreignColumn  = "foreign_col"
					, onDelete       = "cascade"
					, onUpdate       = "set null"
				);

				expect( result ).toBe( expected );
			} );

			it( "should return well fomatted sql with no onDelete or onUpdate rules when passed 'error' for rules", function(){
				var expected = "alter table `source_table` add constraint `fk_name` foreign key ( `source_col` ) references `foreign_table` ( `foreign_col` )";
				var result   = adapter.getForeignKeyConstraintSql(
					  sourceTable    = "source_table"
					, sourceColumn   = "source_col"
					, constraintName = "fk_name"
					, foreignTable   = "foreign_table"
					, foreignColumn  = "foreign_col"
					, onDelete       = "error"
					, onUpdate       = "error"
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getIndexSql()", function(){

			it( "should return well formed index sql", function(){
				var expected = "create index `ix_index` on `table_name` ( `col1`, `col2`, `col3` )";
				var result   = adapter.getIndexSql(
					  indexName = "ix_index"
					, tableName = "table_name"
					, fieldList = "col1,col2,col3"
				);

				expect( result ).toBe( expected );
			} );

			it( "should return well formed unique index sql", function(){
				var expected = "create unique index `ux_index` on `table_name` ( `col1`, `col2`, `col3` )";
				var result   = adapter.getIndexSql(
					  indexName = "ux_index"
					, tableName = "table_name"
					, fieldList = "col1,col2,col3"
					, unique    = true
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getAlterColumnSql()", function(){

			it( "should return well formed sql for altering a column", function(){
				var expected = "alter table `my_table` change `id` `id` int not null auto_increment";
				var result   = adapter.getAlterColumnSql(
					  tableName     = "my_table"
					, columnName    = "id"
					, dbType        = "int"
					, nullable      = false
					, autoIncrement = true
				);

				expect( result ).toBe( expected );
			} );

			it( "should not include primary key assignment when column is PK because MySQL barfs claiming multiple PKs", function(){
				var expected = "alter table `my_table` change `id` `id` varchar(35) not null";
				var result   = adapter.getAlterColumnSql(
					  tableName     = "my_table"
					, columnName    = "id"
					, dbType        = "varchar"
					, maxLength     = "35"
					, nullable      = false
					, autoIncrement = false
					, primaryKey    = true
				);

				expect( result ).toBe( expected );
			} );

			it( "should be able to rename a column", function(){
				var expected = "alter table `my_table` change `col_a` `new_name` varchar(35) not null";
				var result   = adapter.getAlterColumnSql(
					  tableName     = "my_table"
					, columnName    = "col_a"
					, newName       = "new_name"
					, dbType        = "varchar"
					, maxLength     = "35"
					, nullable      = false
					, autoIncrement = false
					, primaryKey    = true
				);

				expect( result ).toBe( expected );
			} );
		} );

		describe( "getAddColumnSql()", function(){
			it( "should return well formed add column statement", function(){
				var expected = "alter table `my_table` add `id` varchar(35) not null primary key";
				var result   = adapter.getAddColumnSql(
					  tableName     = "my_table"
					, columnName    = "id"
					, dbType        = "varchar"
					, maxLength     = "35"
					, nullable      = false
					, autoIncrement = false
					, primaryKey    = true
				);

				expect( result ).toBe( expected );
			} );
		} );

		describe( "getDropIndexSql()", function(){

			it( "should return well formed drop index statement", function(){
				var expected = "alter table `some_table` drop index `ix_my_index`";
				var result = adapter.getDropIndexSql(
					  tableName = "some_table"
					, indexName = "ix_my_index"
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getDropForeignKeySql()", function(){

			it( "should return well formed drop foreign key sql", function(){
				var expected = "alter table `some_table` drop foreign key `fk_foreign_key__here__yes`";
				var result = adapter.getDropForeignKeySql(
					  tableName      = "some_table"
					, foreignKeyName = "fk_foreign_key__here__yes"
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getUpdateSql()", function(){

			it( "should return simple update sql", function(){
				var expected = "update `a_table` set `column_a` = :set__column_a, `column_b` = :set__column_b where `column_c` = :column_c and `column_d` = :column_d";
				var result = adapter.getUpdateSql(
					  tableName     = "a_table"
					, updateColumns = [ "column_a", "column_b" ]
					, filter        = { column_c="test", column_d=4 }
				);

				expect( result ).toBe( expected );
			} );

			it( "should return update sql with joins when joins are passed", function(){
				var expected = "update `event` `e` inner join `cat` `c` on (`c`.`id` = `e`.`cat`) left join `test` `t` on (`t`.`col` = `c`.`test`) set `e`.`column_a` = :set__column_a, `e`.`column_b` = :set__column_b where `cat`.`column_d` = :cat__column_d and `e`.`column_c` = :column_c";
				var result = adapter.getUpdateSql(
					  tableName     = "event"
					, tableAlias    = "e"
					, updateColumns = [ "column_a", "column_b" ]
					, filter        = { column_c="test", "cat.column_d"=4 }
					, joins         = [{
						  tableName    = "cat"
						, tableAlias   = "c"
						, tableColumn  = "id"
						, joinToTable  = "e"
						, joinToColumn = "cat"
						, type         = "inner"

					  },{
						  tableName    = "test"
						, tableAlias   = "t"
						, tableColumn  = "col"
						, joinToTable  = "c"
						, joinToColumn = "test"
						, type         = "left"

					  }]
				);

				expect( result ).toBe( expected );
			} );

			it( "should return update sql with plain text filter", function(){
				var expected = "update `a_table` set `column_a` = :set__column_a, `column_b` = :set__column_b where this.is > :my__filter or test = :nice__test";
				var result = adapter.getUpdateSql(
					  tableName     = "a_table"
					, updateColumns = [ "column_a", "column_b" ]
					, filter        = "this.is > :my.filter or test = :nice.test"
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getDeleteSql()", function(){

			it( "should return simple delete sql", function(){
				var expected = "delete from `test_table` where `another_col` = :another_col and `my_column` = :my_column";
				var result = adapter.getDeleteSql(
					  tableName = "test_table"
					, filter    = { my_column="test", another_col="test" }
				);

				expect( result ).toBe( expected );
			} );

			it( "should work with plain text filter", function(){
				var expected = "delete from `test_table` where myfilter > :your__filter";
				var result = adapter.getDeleteSql(
					  tableName = "test_table"
					, filter    = "myfilter > :your.filter"
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getInsertSql()", function(){

			it( "should return simple insert sql", function(){
				var expected = ["insert into `event_category` ( `col_a`, `col_b`, `col_c` ) values ( :col_a, :col_b, :col_c )"];
				var result = adapter.getInsertSql(
					  tableName     = "event_category"
					, insertColumns = [ "col_a", "col_b", "col_c" ]
				);

				expect( result ).toBe( expected );
			} );

			it( "should return multi insert sql when more than one row specified", function(){
				var expected = ["insert into `event_category` ( `col_a`, `col_b`, `col_c` ) values ( :col_a_1, :col_b_1, :col_c_1 ), ( :col_a_2, :col_b_2, :col_c_2 ), ( :col_a_3, :col_b_3, :col_c_3 )"];
				var result = adapter.getInsertSql(
					  tableName     = "event_category"
					, insertColumns = [ "col_a", "col_b", "col_c" ]
					, noOfRows      = 3
				);

				expect( result ).toBe( expected );
			} );

		} );

		describe( "getSelectSql()", function(){

			it( "should return simple select sql", function(){
				var expected = "select `id`, label, event_date from `event` where `event_category`.`test` = :event_category__test and `event_date` = :event_date order by event_category, sort_order desc";
				var result = adapter.getSelectSql(
					  tableName     = "event"
					, selectColumns = [ "`id`", "label", "event_date" ]
					, filter        = { "event_category.test" = "test", event_date="2012-09-21" }
					, orderBy       = "event_category, sort_order desc"
				);

				expect( result ).toBe( expected );
			} );

			it( "should work with plain text filter", function(){
				var expected = "select `id`, label, event_date from `event` where event_category.test = :test and DateDiff( event_date, Now() ) > :date__diff order by event_category, sort_order desc";
				var result = adapter.getSelectSql(
					  tableName     = "event"
					, selectColumns = [ "`id`", "label", "event_date" ]
					, filter        = "event_category.test = :test and DateDiff( event_date, Now() ) > :date.diff"
					, orderBy       = "event_category, sort_order desc"
				);

				expect( result ).toBe( expected );
			} );

			it( "should allow for join specifications", function(){
				var expected = "select e.col from `event` `e` inner join `cat` `c` on (`c`.`id` = `e`.`cat`) and (`blah` = `blah`) left join `test` `t` on (`t`.`col` = `c`.`test`)";
				var result = adapter.getSelectSql(
					  tableName     = "event"
					, tableAlias    = "e"
					, selectColumns = [ "e.col" ]
					, joins         = [{
						  tableName    = "cat"
						, tableAlias   = "c"
						, tableColumn  = "id"
						, joinToTable  = "e"
						, joinToColumn = "cat"
						, type         = "inner"
						, additionalClauses = "`blah` = `blah`"

					  },{
						  tableName    = "test"
						, tableAlias   = "t"
						, tableColumn  = "col"
						, joinToTable  = "c"
						, joinToColumn = "test"
						, type         = "left"

					  }]
				);

				expect( result ).toBe( expected );
			} );

			it( "should allow group by specification", function(){
				var expected = "select `id`, label, Count(*) as counts from `event` where `event_category`.`test` = :event_category__test and `event_date` = :event_date group by `id` order by event_category, sort_order desc";
				var result = adapter.getSelectSql(
					  tableName     = "event"
					, selectColumns = [ "`id`", "label", "Count(*) as counts" ]
					, filter        = { "event_category.test" = "test", event_date="2012-09-21" }
					, orderBy       = "event_category, sort_order desc"
					, groupBy       = "`id`"
				);

				expect( result ).toBe( expected );
			} );

			it( "should throw meaninful error when joins are not specified with required fields", function(){
				expect( function(){
					adapter.getSelectSql(
						  tableName     = "event"
						, tableAlias    = "e"
						, selectColumns = [ "e.col" ]
						, joins         = [{
							  tableName    = "cat"
							, tableAlias   = "c"
							, tableColumn  = "id"
							, joinToTable  = "event"
							, joinToColumn = "cat"
							, type         = "inner"

						  },{}]
					);

				} ).tothrow( "MySqlAdapter.missingJoinParams" );
			} );

			it( "should return sql with LIMIT syntax when max rows specified", function(){
				var expected = "select `id` from `event` limit 0, 10";
				var result = adapter.getSelectSql(
					  tableName     = "event"
					, selectColumns = [ "`id`" ]
					, maxRows       = 10
				);

				expect( result ).toBe( expected );
			} );

			it( "should return sql with LIMIT syntax when max rows and start row specified", function(){
				var expected = "select `id` from `event` limit 10, 10";
				var result = adapter.getSelectSql(
					  tableName     = "event"
					, selectColumns = [ "`id`" ]
					, maxRows       = 10
					, startRow      = 11
				);

				expect( result ).toBe( expected );
			} );
		} );

		describe( "sqlDataTypeToCfSqlDatatype()", function(){

			it( "should return CFML equivalent for all mysql datatypes", function(){
				var matrix = {
					  cf_sql_bigint        = [ "bigint signed", "int unsigned", "bigint"                                             ]
					, cf_sql_binary        = [ "binary"                                                                              ]
					, cf_sql_bit           = [ "bit", "bool"                                                                         ]
					, cf_sql_blob          = [ "blob"                                                                                ]
					, cf_sql_char          = [ "char"                                                                                ]
					, cf_sql_date          = [ "date"                                                                                ]
					, cf_sql_decimal       = [ "decimal"                                                                             ]
					, cf_sql_double        = [ "double", "double precision", "real"                                                  ]
					, cf_sql_integer       = [ "mediumint signed", "mediumint unsigned", "int signed", "mediumint", "int", "integer" ]
					, cf_sql_longvarbinary = [ "mediumblob","longblob","tinyblob"                                                    ]
					, cf_sql_clob          = [ "text","mediumtext","longtext"                                                        ]
					, cf_sql_numeric       = [ "numeric", "bigint unsigned"                                                          ]
					, cf_sql_real          = [ "float"                                                                               ]
					, cf_sql_smallint      = [ "smallint signed", "smallint unsigned", "tinyint signed", "tinyint", "smallint"       ]
					, cf_sql_timestamp     = [ "datetime","timestamp"                                                                ]
					, cf_sql_tinyint       = [ "tinyint unsigned"                                                                    ]
					, cf_sql_varbinary     = [ "varbinary"                                                                           ]
					, cf_sql_varchar       = [ "varchar", "tinytext", "enum", "set"                                                  ]
				};

				for( var cfType in matrix ){
					for( var mysqlType in matrix[ cfType ] ) {
						var result = adapter.sqlDataTypeToCfSqlDatatype( mysqlType );
						expect( result ).toBe( cfType );
					}
				}
			} );

		} );

		describe( "getClauseSql()", function(){

			it( "should return empty string when no filter supplied", function(){
				var expected = "";
				var result = adapter.getClauseSql( filter={} );

				expect( result ).toBe( expected );
			} );

			it( "should return simple sql when filters supplied", function(){
				var expected = " where `another_col` = :another_col and `some_col` = :some_col";
				var result = adapter.getClauseSql( filter={
					  some_col    = "blah"
					, another_col = "test"
				} );

				expect( result ).toBe( expected );
			} );

			it( "should add aliases to bare columns when table alias supplied", function(){
				var expected = " where `blah`.`another_col` = :blah__another_col and `alias`.`some_col` = :some_col";
				var result = adapter.getClauseSql( tableAlias="alias", filter={
					  some_col           = "blah"
					, "blah.another_col" = "test"
				} );

				expect( result ).toBe( expected );
			} );

			it( "should use IN syntax when value is an array", function(){
				var expected = " where `some_col` in ( :some_col )"
				var result = adapter.getClauseSql( filter={
					  some_col = [ "blah", "yeah", "fubar", "test" ]
				} );

				expect( result ).toBe( expected );
			} );

			it( "should prepend WHERE to supplied filter when filter is a string", function(){
				var expected = " where ( this = :that or test = :whatever )"
				var result = adapter.getClauseSql( filter="( this = :that or test = :whatever )" );

				expect( result ).toBe( expected );
			} );

			it( "should replace dots with double underscores from filter params when filter is a string", function(){
				var expected = " where ( this.that = :that__this or test.fubar = :whatever__test )"
				var result = adapter.getClauseSql( filter="( this.that = :that.this or test.fubar = :whatever.test )" );

				expect( result ).toBe( expected );
			} );

		} );
	}
}
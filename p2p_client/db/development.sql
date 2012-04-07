SQLite format 3   @     1   '           H                                                 1 -�   �    $��������                                             �R�tableusersusersCREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "confirmation_token" varchar(255), "confirmed_at" datetime, "confirmation_sent_at" datetime, "created_at" datetime, "updated_at" datetime)�=/�/indexunique_schema_migrationsschema_migrationsCREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version")q//�tableschema_migrationsschema_migrationsCREATE TABLE "schema_migra                      	       � �������p^L:(�������tbP>,����                                                                                                                                                                                                                                                                                                                                                                                         )20120406000701)20120404220618)20120404211205)20120403180426)20120331175747)20120320173805)20111205163847)20111203051724)20111202232726)20111202062344)20111126234645)20111124075908)20111124074140)20111106041819)20111106014859)20111105000729)20111104223801)20111104203621)20111028230152)20111028212144)20111028190000)20111016184913
)20111016184912	)20111015033818)20111015001555)20111015001341)20111015000221)20111014211848)20111008205911)20111008201818)20110930203851)20110930192920
    � ������{hUB/	�������q^K8%������                                                                                                                                                                                                                                                                                                                                                        )20120406000701 )20120404220618)20120404211205)20120403180426)20120331175747)20120320173805)20111205163847)20111203051724)20111202232726)20111202062344)20111126234645)20111124075908)20111124074140)20111106041819)20111106014859)20111105000729)20111104223801)20111104203621)20111028230152)20111028212144)20111028190000)20111016184913)20111016184912
)20111015033818	)20111015001555)20111015001341)20111015000221)20111014211848)20111008205911)20111008201818)20110930203851)20110930192920                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 � ����                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       #ipaddresses	items
mydata#sellerringsu & &�#qqq/�tableschema_migrationsschema_migrationsCREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL)�=/�/indexunique_schema_migrationsschema_migrationsCREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version")  ��Atableusersusersq//�tableschema_migrationsschema_migrationsCREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL)�=/�/indexunique_schema_migrationsschema_migrationsCREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version")P++Ytablesqlite_sequencesqlite_sequenceCREATE TABLE sqlite_sequence(name,seq)  �5�indexindex_users_on_emailusersCREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email")   �S�Gindexindex_users_on_reset_password_tokenusers	CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token")   �O�?indexindex_users_on_confirmation_tokenusers
CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "users" ("confirmation_token")
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ! !:0�T s                                                                                                  P++Ytablesqlite_sequencesqlite_sequenceCREATE TABLE sqlite_sequence(name,seq)e5�indexindex_users_on_emailusersCREATE UNIQUE INDEX "index_users_on_email" ON "u��tableitemsitemsCREATE TABLE "items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" varchar(255), "condition" boolean, "starting_price" decimal, "duration" integer, "category" varchar(255), "seller_id" integer, "created_at" datetime, "updated_at" datetime, "photo_file_name" varchar(255), "photo_content_type" varchar(255), "photo_file_size" integer, "photo_updated_at" datetime, "expires_at" datetime, "bidding_closed" boolean, "is_paid" boolean, "for_sale" boolean, "buy_price" decimal)�C	!!�QtablecategoriescategoriesCREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "parentID" integer, "created_at" datetime, "updated_at" datetime)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
         	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  �  ��S                                                                                                                                                                   }A#�#indexindex_admin�
##�Utableadmin_usersadmin_usersCREATE TABLE "admin_users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime, "updated_at" datetime)}A#�#indexindex_admin_users_on_emailadmin_usersCREATE UNIQUE INDEX "index_admin_users_on_email" ON "admin_users" ("email")�*_#�_indexindex_admin_users_on_reset_password_tokenadmin_usersCREATE UNIQUE INDEX "index_admin_users_on_reset_password_token" ON "admin_users" ("reset_password_token")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  o  o� $                      �S�Gindexindex_users_on_reset_password_tokenusers	CREATE UNIQUE INDEX�'�-tableusersusersCREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(128) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "confirmation_token" varchar(255), "confirmed_at" datetime, "confirmation_sent_at" datetime, "created_at" datetime, "updated_at" datetime, "first_name" varchar(255), "last_name" varchar(255), "street" varchar(255), "city" varchar(255), "zip" varchar(255), "state" varchar(255), "phone" integer, "country" varchar(255), "dob" date, "is_seller" boolean)e5�indexindex_users_on_emailusersCREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email")    �  �@�,�                                                  �Z77�Stableactive_admin_commentsactive_admin_commentsCREATE TABLE "active_admin_comments" ("id" IN�S�Gindexindex_users_on_reset_password_tokenusers	CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token")�O�?indexindex_users_on_confirmation_tokenusers
CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "users" ("confirmation_token")�Z77�Stableactive_admin_commentsactive_admin_commentsCREATE TABLE "active_admin_comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "resource_id" integer NOT NULL, "resource_type" varchar(255) NOT NULL, "author_id" integer, "author_type" varchar(255), "body" text, "created_at" datetime, "updated_at" datetime, "namespace" varchar(255))�Qq7�indexindex_admin_notes_on_resource_type_and_resource_idactive_admin_commentsCREATE INDEX "index_admin_notes_on_resource_type_and_resource_id" ON "active_admin_comments" ("resource_type", "resource_id")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                P  P ��� L                                                             �*]7�Mindexindex_active_admin_comments_on_namespaceactive_admin_commentsCREATE INDEX "index_active_admin_comments_on_namespace" ON "active_admin_comments" ("namespace")�Y}7�indexindex_active_admin_comments_on_author_type_and_author_idactive_admin_commentsCREATE INDEX "index_active_admin_comments_on_author_type_and_author_id" ON "active_admin_comments" ("author_type", "author_id")�e�tablebiddingsbiddingsCREATE TABLE "biddings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "bid_time" datetime, "bid_amount" integer, "created_at" datetime, "updated_at" datetime, "user_id" integer, "item_id" integer)�<�KtablesearchessearchesCREATE TABLE "searches" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "keywords" varchar(255), "category_id" integer, "minimum_price" float, "maximum_price" float, "ending_time" datetime, "condition" boolean, "created_at" datetime, "updated_at" datetime, "seller_email" varchar(255))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            �  ��v    �@!!�KtablewatchlistswatchlistsCREATE TABLE "watchlists" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "item_id" integer, "created_at�''�otablenotificationsnotificationsCREATE TABLE "notifications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "item_id" integer, "delivered" boolean, "created_at" datetime, "updated_at" datetime, "message" varchar(255), "notification_type" varchar(255))�$�'tablecartscartsCREATE TABLE "carts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "purchased_at" datetime, "created_at" datetime, "updated_at" datetime)��itableordersordersCREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "card_type" varchar(255), "card_expires_on" date, "street" varchar(255), "city" varchar(255), "zip" varchar(255), "state" varchar(255), "phone" integer, "country" varchar(255), "cart_id" integer, "created_at" datetime, "updated_at" datetime)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            �  �KM�                                                                                                                  �g�@!!�KtablewatchlistswatchlistsCREATE TABLE "watchlists" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "item_id" integer, "created_at" datetime, "updated_at" datetime)�!!�Itableline_itemsline_itemsCREATE TABLE "line_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "unit_price" decimal, "item_id" integer, "cart_id" integer, "quantity" integer, "item_paid" boolean, "created_at" datetime, "updated_at" datetime)�F--�?tablecategory_memberscategory_members!CREATE TABLE "category_members" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "ipAddress" varchar(255), "updated_at" datetime, "created_at" datetime)�g##�tableipaddressesipaddresses"CREATE TABLE "ipaddresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "ipaddress" varchar(255), "iptype" varchar(255), "category" varchar(255), "created_at" datetime, "updated_at" datetime)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ] �]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 L #AAparentElectronics2012-04-07 19:09:50.0818172012-04-07 19:09:50.081817S +AA128.237.240.210parentMen2012-04-06 01:01:44.9517202012-04-06 01:01:44.951720   � �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        '   128.237.233.5bootstrap    u  u_MD C                                                    �t ''�'tablesearchresultssearchresults&CREA�g##�tablesellerringssellerrings#CREATE TABLE "sellerrings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "ipaddress" varchar(255), "iptype" varchar(255), "category" varchar(255), "created_at" datetime, "updated_at" datetime)�k�%tablesearchdbssearchdbs%CREATE TABLE "searchdbs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "buyeripaddress" varchar(255), "searchquery" varchar(255), "category" varchar(255), "created_at" datetime, "updated_at" datetime)�t ''�'tablesearchresultssearchresults&CREATE TABLE "searchresults" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "search_string" varchar(255), "category" varchar(255), "ipaddress" varchar(255), "created_at" datetime, "updated_at" datetime)�9!�Mtablemydatamydata'CREATE TABLE "mydata" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "is_seller" boolean, "created_at" datetime, "updated_at" datetime)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               X �X                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            R ;AAjkallahe@andrew.cmu.edut2012-04-07 19:08:47.4483422012-04-07 19:08:47.448342R ;AAjkallahe@andrew.cmu.edut2012-04-06 00:50:17.0493842012-04-06 00:50:17.049384
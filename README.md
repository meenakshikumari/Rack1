# Rack1
Rack Application for getting json response of users from the database for a given user

1. Make a database named "testdb" in Postgresql consisting of user table with field name and email(unique)
eg: 

    | name  | email |
    | ------------- | ------------- |
    | User1 | user1@gmail.com |
    | User3  | user3@gmail.com  |
    | User2  | user2@gmail.com  |
    | User2 | user21@gmail.com |
    | User3  | user31@gmail.com  |
    | User2  | user22@gmail.com  |
    | User3  | user32@gmail.com  |
    
2. Start localhost "http://localhost:9595/" and add username and password as demo .

3. After succesfull login hit "http://localhost:9595/getusers?name=User3" API and will see the json response for
   the User3 consisting of name and email of all the users named User3.

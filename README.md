Lets create an android application using Flutter which will have below features.
- this app will be solely for me and my friend 2 users, so we will not add any security | no backend server | only mongodb which will be free, so we will make all the requests from the application itself to the db.
- tracking the revision of each and every topic according to the following algorithm
- Revision Tracker app we have to make to track the revision of each thing.
  NO Security should be there as this is only personal app used by me and my friend | so whenever app opens up, it will just ask for a userId which will be our names and mongo will already have data for the user | so it will fetch and show up | no password nothing |
```Revision Tracker.  
-- Topic studied for first time lets say on Oct 1, then 
	-- 1st revision should be within 24 hrs which is Oct 2
	-- 2nd Revision will be 3 days ahead that is 5 Oct. 
	-- 3rd revision will be after 7 days of previous revision that is on 12 oct. 
	-- 4th on will be after 7 days of previous revision i.e., 19 oct. 
	-- 5th on will be after 7 days of previous revision i.e., 26 oct.  
	-- 6th revision will be after 60 days from previous revision i.e., 25 Dec
	-- 7th will be after 4 months from previous revision i.e., April 23/24 considering the leap year.
```

```Implementation
1. Setup the project with proper dependencies. 
2. Create mongo db atlas connector which will have proper methods for our project and the connection string will be harcoded
3. Define the proper model/s for the mongo to interact to and other model/s which might be necessary in the application.
4. Make the UI screens and everything according to below. 

```User Flow
- After launching the app user can enter his name 
-> name will be stored in cache so that next time user doesn't has to enter again 
-> If user is not registered then he will be asked if want to create a new user and then with basic default empty values a new user document will be created in the mongoDB
-> user can see what all topics he has to revise today based on the mongodb data which will be shown in cards and he can tick them which will update in the mongo that the revision of that particular iteration is complete 
-> For showing the dashboard of revision cards we will use teams interface of showing up the agenda for the day.
-> the navigation will be in the bottom which will have home button which will be default showing the revision cards for today 
-> next tab will be add new topic 
-> this will allow user to add the topic learnt today by properly filling up the form for categoryName, subcategoryName, topicName, notes & startDate which will be automatically decided based on today's date 
-> while filling up the categoryName, subcategoryName the existing categories and subcategories will be fetched from the mongo for the user so that user can select either from them or just create a new one | after submitting the form the revisionDates will be created for the topic according to the algorithm and stored in the mongo db atlas.
```
```Mongo-Connection String -
`mongodb+srv://admin:1234@revision.j1dld.mongodb.net/?retryWrites=true&w=majority&appName=revision`
database-name = `revision-data`
```
Mongo Document structure -
```
{
  "_id": "ObjectId",
  "userId": "userName",            // Reference to the user
  "categories": [
    {
      "categoryName": "string",    // e.g., "UPSC"
      "subcategories": [
        {
          "subcategoryName": "string",    // e.g., "Polity"
          "topics": [
            {
              "topicName": "string",           // Name of the topic
              "notes": "string",               // Optional notes about the topic
              "startDate": "ISODate",          // Date when the topic was first studied
              "revisionDates": [
                {
                  "revisionNumber": "number",    // 1, 2, 3, etc.
                  "revisionDate": "ISODate",     // Calculated revision date
                  "completed": "boolean"         // Whether the revision was completed
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```
```Sample 
{
  "_id": "ObjectId('66587b1ef734de432934f5e2')",
  "userId": "MyName",
  "categories": [
    {
      "categoryName": "UPSC",
      "subcategories": [
        {
          "subcategoryName": "Geography",
          "topics": [
            {
              "topicName": "Indian Rivers",
              "notes": "Study major rivers and their tributaries",
              "startDate": "2024-05-31T00:00:00.000Z",
              "revisionDates": [
                {
                  "revisionNumber": 1,
                  "revisionDate": "2024-06-01T00:00:00.000Z",
                  "completed": false
                },
                {
                  "revisionNumber": 2,
                  "revisionDate": "2024-06-04T00:00:00.000Z",
                  "completed": false
                },
                // Additional revisions...
              ]
            }
          ]
        },
        {
          "subcategoryName": "Polity",
          "topics": [
            {
              "topicName": "Constitutional Amendments",
              "notes": "Focus on key amendments",
              "startDate": "2024-05-31T00:00:00.000Z",
              "revisionDates": [
                {
                  "revisionNumber": 1,
                  "revisionDate": "2024-06-01T00:00:00.000Z",
                  "completed": false
                },
                // Additional revisions...
              ]
            }
          ]
        }
      ]
    },
    // Additional categories...
  ]
}
```
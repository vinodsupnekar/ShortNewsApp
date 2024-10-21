# ``ShortNewsApp``

  App that delivers News in very Short

## Overview

Example:- title : NYT plagiarism consultant admits Harris scandal 'more serious' than he thought

API URL :- https://riad-news-api.vercel.app/api/news/source?code=US-FN

        description : Plagiarism consultant Jonathan Bailey admitted the allegations against Vice President Kamala Harris are more significant than he described to the New York Times.

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

Story: Customer requests to see latest news feed in short

Narrative #1:- 
As online user,
I want the App to automatically load latest new feeds.
So I can see latest news all the time.

## Sceanrios (Acceptance criteria):- 
Given User has connectivity
 When user request to see latest news 
  Then , the app should display latest news fedd from remote on top.


Narrative #2:- 
As offline user,
I want the App to display retry mechanism to be able to reconnect and fetch news feeds.

## Sceanrios (Acceptance criteria):- 

Given User has does not have connectivity
 When user request to see latest news 
  Then , app should display retry UI with proper message for user.

Given User has does not have connectivity
 And user request to see latest news 
 When user interacts with refresh UI and user has connectivity
  Then , app should fetch news feeds and  display news.


## Use Cases***

### Load News Feed From Remote Use Case

Data: 
    URL

Primary course: (Happy Path)
  1.Execute load news feed command with above data.
  2.System downloads data from the URL
  3.System creates news feed from valid data.
  4.System delivers news feed with latest news feed on top.

Invalid data – error course (sad path):
    System delivers invalid data error.

No connectivity – error course (sad path):
    System delivers connectivity error with retry mechanism UI 


### Retry News Feed Use Case

Primary course: (Happy Path)
  1.Execute refresh news feed command with above data.
  2.System downloads data from the URL
  3.System creates news feed from valid data.
  4.System delivers news feed UI and hides refresh error UI.

Invalid data – error course (sad path):
    System delivers invalid data error with Refresh UI.

No connectivity – error course (sad path):
    System delivers connectivity error with retry mechanism UI 

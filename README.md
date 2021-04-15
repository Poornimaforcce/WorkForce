# WorkForce
# Problem:

A Case has been updated to be closed. When a Case is closed, the workforce planning team need to be notified to ensure they are correctly tracking Case closures and new work assignments. This is currently handled by an API call to the workforce management platform.
The environment is a relatively high volume environment with roughly 200 Case closures per minute. The API recently has had some performance issues and every now and again it times out.
It’s not necessary for the API to be called immediately after the case is closed, as long as the workforce management platform is notified within the day. 
The case should be updated with the secretKey returned from the API.
We are looking for a workable (or semi-workable) solution that addresses the following key points:
1.	Code style and structure
2.	Solution one-pager outlining inclusions, exclusions, justifications
3.	Ability to write well structured, efficient unit test classes 
4.	Ideas (and possible implementation) for a fail-over strategy where API fails
5.	Code checked into GIT for review
We would like this challenge to be completed within a week. Please let us know if that is not possible.

# Approach:

1)	I used the Batch and Schedule approach to fetch all the closed CASE records which does not have secret key. 
2)	Batch class to get the closed CASE and send to workforce API with the Batch size is 90 for each Batch.
3)	Schedular class to schedule batch class at the interval of 10 mins.
4)	If it is a failure comes from API in next Batch, the failed record also got end to the API.

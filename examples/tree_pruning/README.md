# The problem

Imagine you have a tree of various Indicators that track something about a country's population. The client wants to display them, but only a few of them at a time.

These Indicators are part of a tree, and they’re grouped by Themes, Sub-themes, and Categories. For example, we have an indicator called “Crude death rate”. It resides in the Category "Births per year", which lives inside the Sub-theme “Births and Deaths”, which in turn lives inside the Theme “Demographics”.

This data comes from a client-provided service, which doesn’t support picking and choosing which things to filter. Because of valid reasons we won’t expound on here, it wouldn’t make sense to add this feature to the upstream service, and it’s on us to build an intermediary service that can do this.


Because we don’t know how to program, this service explodes quite regularly. It’s expected that your solution should retry a few times in case of failure.

You can find sample input data in the test suite

## Solution

You’re to make an API that has one single endpoint, /tree/<name>. It will receive the name of the upstream tree to request, as well as a list of values as GET params, indicator_ids[] to filter for. If you get asked to show an Indicator, you should return the subtree that reaches it. Here's an example URL:

    http://127.0.0.1:5000/tree/input?indicator_ids[]=31&indicator_ids[]=32&indicator_ids[]=1

Except for filtering out uninteresting Categories, Sub-themes and Themes, you must preserve all the other attributes in the nodes.

## Potential edge cases

After an earnest try to maintain service, if the upstream still doesn’t work, return a 500.
If the tree you were asked for does not exist, return a 404.

The upstream server has no schedule for changes. Don’t cache its answers.

## Things that we’ll pay attention to

* Code ergonomy (style and readability)
* Testing strategy
* Resilience to network/upstream problems
* Separation of concerns and code structure

## Visualization of a pruned tree

In the tree below, when asked for the four indicators in bold (Urban, Male, Female, >30y), you should return a subtree containing only the highlighted nodes.

| Theme              | Sub-Theme            | Category                 | Indicator       |
|-------------       |----------------      |----------------          |-----------------|
| `Urban`            | `Administrative`     | `Area`                   | Rural           |        
| `Urban`            | `Administrative`     | `Area`                   | **Urban**       |        
| `Urban`            | `Administrative`     | Population               | Total           |        
| `Urban`            | `Administrative`     | Population               | Male            |        
| `Urban`            | `Administrative`     | Population               | Female          |        
| Jobs               | Labor force          | Working population       | Total           |        
| Jobs               | Unemployment         | 15-24 years              | Male            |        
| Jobs               | Unemployment         | 15-24 years              | Female          |        
| `Demographics`     | `Birth and deaths`   | Deaths per year          | Natural         |        
| `Demographics`     | `Birth and deaths`   | Deaths per year          | Accidents?      |        
| `Demographics`     | `Birth and deaths`   | Deaths per year          | Murder          |        
| `Demographics`     | `Birth and deaths`   | `Births per year`        | **Male**        |        
| `Demographics`     | `Birth and deaths`   | `Births per year`        | **Female**      |        
| `Demographics`     | `Age and sex`        | `Age distribution`       | < 3y            |
| `Demographics`     | `Age and sex`        | `Age distribution`       | <18y            |
| `Demographics`     | `Age and sex`        | `Age distribution`       | <30y            |
| `Demographics`     | `Age and sex`        | `Age distribution`       | **>30y**        |
| `Demographics`     | `Age and sex`        | Sex                      | Yes             |
| `Demographics`     | `Age and sex`        | Sex                      | No              |


The resulting (pruned) tree should be this:

| Theme              | Sub-Theme            | Category                 | Indicator       |
|-------------       |----------------      |----------------          |-----------------|
| `Urban`            | `Administrative`     | `Area`                   | **Urban**       |   
| `Demographics`     | `Birth and deaths`   | `Births per year`        | **Male**        |        
| `Demographics`     | `Birth and deaths`   | `Births per year`        | **Female**      |  
| `Demographics`     | `Age and sex`        | `Age distribution`       | **>30y**        |  

# Result

Finish endpoint can used with

```
curl -v 'http://127.0.0.1:3000/?indicator_ids\[\]=31&indicator_ids\[\]=32&indicator_ids\[\]=1'
```

In the real world will be good to move all exceptions handling to `ApplicationController`
but now I think it is ok as it is.

I still do not have real endpoint. Use stub file is not right, so I leaved stub uri. 
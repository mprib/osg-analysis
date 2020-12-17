# Historical Data Processing Steps as I Begin
 
The original data files used in this study were taken from the data set described here:

  https://www.nature.com/articles/s41597-019-0124-4

In order to access the files you must go to the 24th citation in the article (figshare):

  https://doi.org/10.6084/m9.figshare.7734767

They are provided in c3d files nested within folders specific to each participant. The files represent 5 conditions (3 speed categories as well as SSWS and fastest) and for each condition there are ~5 recordings. This produces 5x5x50 participants = 1250 files, not including the static trials used for fitting the model to the markers.

I wrote two scripts (1_Create_Pipelines.R and 2_ConsolidateTextFileOutput.R) in the summer of 2020 in order to facilitate data processing. I find myself today (December 5, 2020) piecing together the work that I previously did to understand exactly where I am.

It looks like this was from a project for Hao to get knee and hip torques along with VGRF. Hao was testing the idea that Healthy subjects modulated force production differently than people after stroke.



## 1_Create_Pipelines.R

I created one sample pipeline for Subject 2014001

In another file (SubjectAnthropometrix.xlsx) I stored all the measurements specific to each participant.

This R script then goes through two major steps:

1. Sets up a loop to iterate over all participants
2. It copies the sample pipeline and replaces the participant specifc data
3. Names this new pipeline out to a new file

In the second major step I combine all the text files into one text file that could then be run within Visual 3D. The goal of this step is to create all of the individual .cmo files that have the appropriate model and participant data to run correctly. Also with all the conditions and runs in one overarching v3d file per participant.

That "one place" is C:\Users\Mac Prible\Box\Research\schreiber-moissenet\data\cmo_files. 

So now I have all these individual cmo files from which I hope to be able to run some standard pipelines to create the output I need. Here's a problem: *I do not know the specific speeds of the participants, and it seems that some of the force plate data is messed up because there are partial reads* from the foot striking only part of the plate. 

The first part will be a problem for me right now. *I need to figure out how to calculate the speed of the participant* within the pipeline.

This is not a problem for me currently because of my goals today (trunk range of motion and midpoints), but *it will be a problem when attempting to model force production*. It looks like I did some one-off stuff in excel to flag records that had bad reads of force before passing it on to Hao. 

## 2_ConsolidateTextFileOutput.R

Looks like this was an attempt to consolidate the output from V3D across multiple .v3s outputs into a single file. While this is somewhat specific to the project I was working on at the time, I think it can be pretty quickly adapted to my needs as they arise in this upcoming project. 

I'm sitting here and wondering why this kind of data doesn't seem to have been reported before, and then I'm looking at what it's going to take to pull all this together, and perhaps the answer should be somewhat clear. 

In the end, the process of pulling everything together is going to be a bit of a mess. But here we are. 

# Initial Plan to Proceed

I will say at the outset that I have concerns about the file structure that I have set up here. The way things either are or are not nested seems like it will create issues down the line. I'm going to give myself permission right now to not worry about that, to just get deep into things and change stuff on the fly. 

When all the chips land I will hopefully have something that makes sense and then I will document the ever loving shit out of it.

Here's the beginning of a task item list:


1. Get your github login working: you were running off an old validation system that has been discontinued. You will want to be running this through a backed up VC. Not sure if my current setup is really working. Ok. Looks like the push to master is working. Very good then. One more thing out of the way.

2. Create a pipeline with a sample participant that calculates the gait speed of a given trial.

3. Add to that pipeline the range of motion and midpoints....make sure that you are not capturing partial gait cycles which will throw off the range.

4. Create a new version of 2_ConsolidateTextFileOutput.R that will consolidate this output.

5. Dig out the AutoHotKey script to create the output that you want. Time how long it takes for this to run so that you can make better plans about this going forward.

6. Start the actual analysis in a new document.
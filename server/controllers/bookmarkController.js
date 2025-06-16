const express = require('express');
const mongoose = require('mongoose');
const bookmarks = require('../models/bookmark');
const Job = require('../models/job'); // Fixed capitalization to match convention
const bookmark = require('../models/bookmark');
module.exports = {
    // always the best  practise to use return before res.status(something);
    createBookmark: async (req, res) => {
        const jobId = req.body.job;
        const userId = req.user.id;
        /*
        -------------------------APPROACH FOR MAKING A BOOKMARK----------------------------
         first we fetched the jobId and userId from the request body and request user as these
         are the field that are required for us to create a bookmark

         then checking if the job exists or not and if it does not exists then we will send the error message
         after that checking if the bookmark is already created or not and if already created then send an error message to the user

         now if the bookmark does not exists then we will create the new bookmark and then save that bookmark in our database
         after successfully saving the bookmark we will then send the user response wuth the bookmark._id 
         that is provided by the mongo db itsel
         */
        try {
            const jobExists = await Job.findById(jobId);
            if (!jobExists) {
                return res.status(404).json({
                    status: false,
                    message: 'Job not found'
                });
            }
            const existingBookmark = await bookmarks.findOne({
                job: jobId,
                userId: userId
            });
            if (existingBookmark) {
                return res.status(400).json({
                    status: false,
                    message: 'Job already bookmarked'
                });
            }
            const newBookmark = new bookmarks({
                job: jobId, 
                userId: userId,
            });
            const savedBookmark = await newBookmark.save();
            return res.status(201).json({
                status: true,
                bookmarkId: savedBookmark._id,
                message: 'Bookmark created successfully'
            });
        } catch (error) {
            console.error('Bookmark creation error:', error);
            return res.status(500).json({
                status: false,
                message: 'Could not create bookmark',
                error: error.message
            });
        }
    },

    deleteBookmark: async(req, res) => {
        const bookmarkId = req.params.id;
        const userId = req.user.id;
        
        try {
            // Find the bookmark first to verify it exists and belongs to this user
            const bookmarkToDelete = await bookmarks.findOne({
                _id: bookmarkId,
                userId: userId
            });
            
            if (!bookmarkToDelete) {
                return res.status(404).json({
                    status: false,
                    message: 'Bookmark not found or not authorized to delete'
                });
            }
            
            // Now delete it and verify deletion
            const deletedBookmark = await bookmarks.findByIdAndDelete(bookmarkId);
            
            if (!deletedBookmark) {
                return res.status(500).json({
                    status: false,
                    message: 'Failed to delete bookmark'
                });
            }
            
            return res.status(200).json({
                status: true,
                message: 'Bookmark deleted'
            });
        } catch(error) {
            return res.status(500).json({
                status: false,
                message: error.message
            });
        }
    },

    getAllBookmarks:  async(req,res)=>{
        const userId = req.user.id;
        try{
            const allBookmarks = await bookmarks.find({
                userId: userId,

            },{createdAt: 0,updatedAt: 0 ,__v: 0
            }).populate(
                {
                    path: 'job',
                    select: "-requirements  -description -createdAt  -updatedAt -__v"
                }
            )
            res.status(200).json(allBookmarks);
        }catch(error){
            res.status(500).json({
                message: error.message,
        })
        }
    },

    getBookmark: async (req, res) => {
        const jobId = req.params.id;
        const userId = req.user.id;
        
        try {
            // Fixed: Changed "jobId" to "job" to match schema
            const oneBookmark = await bookmarks.findOne({
                userId: userId,
                job: jobId  // ✅ CORRECT: Field name matches your schema
            });
            
            // Added null check
            if (!oneBookmark) {
               return res.status(200).json(
                null
               );
            }
            
            return res.status(200).json({
                status: true,
                bookmarkId: oneBookmark._id
            });
        } catch (error) {
            console.error('Error fetching bookmark:', error);
            return res.status(500).json({  // Changed from 402 to 500
                status: false,
                message: error.message
            });
        }
    },
};
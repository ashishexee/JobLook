const User = require("../models/user");
const admin = require("firebase-admin");
const Skills = require("../models/skills");
const Agent = require("../models/agent");

module.exports = {
  updateUser: async (req, res) => {
    const userId = req.user.id;
    try {
      await User.findByIdAndUpdate(userId, { $set: req.body }, { new: true });
      return res.status(200).json({
        status: true,
        message: "user updated",
      });
    } catch (error) {
      return res.status(500).json({
        status: false,
      });
    }
  },

  deleteUser: async (req, res) => {
    const userId = req.user.id;
    try {
      await User.findByIdAndDelete(userId);
      await admin.deleteUser(req.user.uid);
      return res.status(200).json({
        status: true,
        message: "user deleted",
      });
    } catch (error) {
      return res.status(500).json({
        status: false,
      });
    }
  },

  getUser: async (req, res) => {
    const userId = req.user.id;
    try {
      const profile = await User.findById(userId);

      if (!profile) {
        return res.status(404).json({
          status: false,
          message: "User not found",
        });
      }

      const { password, createdAt, updatedAt, __v, ...userData } = profile._doc;
      return res.status(200).json(userData);
    } catch (error) {
      console.error("Error fetching user:", error);
      return res.status(500).json({
        status: false,
        message: "Failed to fetch user data",
        error: error.message,
      });
    }
  },

  addSkill: async (req, res) => {
    const userId = req.user.id;
    const newSkill = new Skills({ userId: userId, skill: req.body.skill });
    try {
      await newSkill.save();
      await User.findByIdAndUpdate(userId, { $set: { skills: true } });
      return res.status(200).json({
        status: true,
      });
    } catch (error) {
      return res.status(500).json({
        error: error,
      });
    }
  },
  getSkills: async (req, res) => {
    const userId = req.user.id;
    try {
      const skills = await Skills.find(
        { userId: userId },
        { createdAt: 0, updatedAt: 0, __v: 0 }
      );
      if (skills.length == 0) {
        return res.status(200).json([]);
      }
      return res.status(200).json(skills);
    } catch (error) {
      return res.status(500).json({
        error: error,
      });
    }
  },
  deleteSkill: async (req, res) => {
    const skillId = req.params.id;
    try {
      await Skills.findByIdAndDelete(skillId);
      return res.status(200).json({
        status: true,
      });
    } catch (error) {
      return res.status(500).json({
        error: error,
      });
    }
  },

  addAgent: async (req, res) => {
    const agentDetails = new Agent({
      userId: req.user.id,
      uid: req.body.uid,
      hq_address: req.body.hq_address,
      company: req.body.company,
      working_hrs: req.body.working_hrs,
    });

    try {
      await agentDetails.save();
      await User.findByIdAndUpdate(req.user.id, { $set: { isAgent: true } });
      return res.status(200).json({
        status: true,
      });
    } catch (error) {
      return res.status(500).json({
        error: error,
      });
    }
  },
  updateAgent: async (req, res) => {
    const agentId = req.params.id;
    try {
      const updatedAgent = await Agent.findByIdAndUpdate(
        agentId,
        {
          working_hrs: req.body.working_hrs,
          company: req.body.company,
          hq_address: req.body.hq_address,
        },
        {
          new: true,
        }
      );
      if (!updatedAgent) {
        return res.status(404).json({
          message: "Agent not found ",
        });
      }
      return res.status(200).json({
        status: true,
      });
      /**
        here we could have done this also for updating
        await Agent.findByIdAndUpdate(agentId ,{$set: {req.body}} ,{
        new: true
      });
      we did not go with this approach because we did not wanted to change all the field
      the userId and uid should have remained unchanged (tho this could have been achieved by the
      req.body but still we learned a new way to update a scheme(if mongoose))
        */
    } catch (error) {
      return res.status(500).json({
        error: error,
      });
    }
  },
  getAgent: async (req, res) => {
    try {
      const agentDetails = await Agent.find(
        { uid: req.params.uid },
        { createdAt: 0, updatedAt: 0, __v: 0 }
      );
      if (!agentDetails) {
        return res.status(404).json({
          message: "could not find the agent",
        });
      }
      // SchemeName.find() this always provides us with a array
      // here we will get only 1 response but the json data will be inside the array of size 1
      // so its better for us to extract the index 0 and return it
      const agent = agentDetails[0];
      return res.status(200).json(agent);
    } catch (error) {
      return res.status(500).json({
        error: error.message,
      });
    }
  },
  getAllAgents: async (req, res) => {
    try {
      const agents = await User.aggregate([
        {
          $match: { isAgent: true }, // // Step 1: Filter to only users with isAgent=true
        },
        {
          $sample: { size: 7 }, // // Step 2: Get a random sample of 7 agents
        },
        {
          $project: {
            // only include these field
            _id: 0, // exclude
            username: 1, // include
            profile: 1, // include
            uid: 1, // include
          },
        },
      ]);
      return res.status(200).json(agents);
    } catch (error) {
      return res.status(500).json({
        error: error.message,
      });
    }
  },
};

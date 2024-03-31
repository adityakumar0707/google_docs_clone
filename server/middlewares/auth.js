const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
    try {
        console.log('1');
        const token = req.header("x-auth-token");
        console.log('2');

        if(!token)
            return res.status(401).json({msg: "No auth token"});

            const verified = jwt.verify(token , "passwordKey");

        if(!verified)
            return res.status(401).json({msg: "Toekn verification failed"});
        req.user = verified.id;
        req.token = token;
        next();
        
    } catch (error) {
        res.status(500).json({error: error.message});

    }
};

module.exports = auth;
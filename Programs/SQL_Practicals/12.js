db.createCollection("Employee")

db.Employee.insertMany([
    {
        Emp_id: 2001,
        Name: {
            FName: "Rajesh",
            LName: "Kumar"
        },
        CompanyName: "Infosys",
        Salary: 120000,
        Designation: "Senior Developer",
        Age: 32,
        Expertise: ["Java", "Spring", "MongoDB", "AWS"],
        DOB: "1993-05-15",
        EmailId: "rajesh.kumar@infosys.com",
        Contact: "9876543220",
        Address: [
            {
                PAddr: "Kalyani Nagar, Pune",
                LAddr: "Worli, Mumbai"
            }
        ]
    },
    {
        Emp_id: 2002,
        Name: {
            FName: "Anjali",
            LName: "Deshmukh"
        },
        CompanyName: "TCS",
        Salary: 150000,
        Designation: "Project Manager",
        Age: 35,
        Expertise: ["Project Management", "Agile", "Scrum"],
        DOB: "1990-08-20",
        EmailId: "anjali.deshmukh@tcs.com",
        Contact: "9876543221",
        Address: [
            {
                PAddr: "Baner, Pune",
                LAddr: "Malad, Mumbai"
            }
        ]
    },
    {
        Emp_id: 2003,
        Name: {
            FName: "Sanjay",
            LName: "Patil"
        },
        CompanyName: "Infosys",
        Salary: 90000,
        Designation: "Senior Developer",
        Age: 30,
        Expertise: ["Python", "Django", "PostgreSQL"],
        DOB: "1995-11-10",
        EmailId: "sanjay.patil@infosys.com",
        Contact: "9876543222",
        Address: [
            {
                PAddr: "Aundh, Pune",
                LAddr: "Andheri, Mumbai"
            }
        ]
    },
    {
        Emp_id: 2004,
        Name: {
            FName: "Meera",
            LName: "Sharma"
        },
        CompanyName: "TCS",
        Salary: 180000,
        Designation: "Project Manager",
        Age: 38,
        Expertise: ["Team Management", "JIRA", "Risk Management"],
        DOB: "1987-03-25",
        EmailId: "meera.sharma@tcs.com",
        Contact: "9876543223",
        Address: [
            {
                PAddr: "Magarpatta, Pune",
                LAddr: "Dadar, Mumbai"
            }
        ]
    },
    {
        Emp_id: 2005,
        Name: {
            FName: "Prakash",
            LName: "Verma"
        },
        CompanyName: "Infosys",
        Salary: 130000,
        Designation: "Senior Developer",
        Age: 33,
        Expertise: ["React", "Node.js", "MongoDB"],
        DOB: "1992-12-05",
        EmailId: "prakash.verma@infosys.com",
        Contact: "9876543224",
        Address: [
            {
                PAddr: "Hinjewadi, Pune",
                LAddr: "Bandra, Mumbai"
            }
        ]
    },
    {
    Emp_id: 2006,
    Name: { 
        FName: "Suresh", 
        LName: "Raina" 
    },
    CompanyName: "TCS",
    Salary: 95000,
    Designation: "DBA",
    Age: 31,
    Expertise: ["Oracle", "MySQL", "PostgreSQL"],
    DOB: "1994-06-15",
    EmailId: "suresh.raina@tcs.com",
    Contact: "9876543225",
    Address: [
        { 
            PAddr: "Viman Nagar, Pune", 
            LAddr: "Thane, Mumbai" 
        }
    ]
    }
])

// Question 1
db.Employee.aggregate([
    {
        $group: {
            _id: "$Designation",
            totalSalary: { $sum: "$Salary" }
        }
    },
    {
        $match: {
            totalSalary: { $gt: 200000 }
        }
    }
])

// Question 2 
db.Employee.aggregate([
    {
        $project: {
            _id: 0,
            upperFirstName: { $toUpper: "$Name.FName" },
            upperLastName: { $toUpper: "$Name.LName" }
        }
    },
    {
        $sort: {
            upperFirstName: 1
        }
    }
])

// Question 3
db.Employee.aggregate([
    {
        $match: { Designation: "DBA" }
    },
    {
        $unwind: "$Address"
    },
    {
        $group: {
            _id: "$Address.PAddr",
            totalSalary: { $sum: "$Salary" }
        }
    }
])

// Question 4
db.Employee.createIndex({ Designation: 1 })

// Question 5
db.Employee.createIndex({ Expertise: 1 })

// Question 6
let bulkOps = [];
for(let i = 2006; i <= 12006; i++) {
    bulkOps.push({
        insertOne: {
            document: {
                Emp_id: i,
                Name: {
                    FName: "Test",
                    LName: "Employee" + i
                },
                CompanyName: "TestCompany",
                Salary: 50000,
                Designation: "Developer",
                Age: 25,
                Expertise: ["Java"],
                DOB: "2000-01-01",
                EmailId: `test${i}@test.com`,
                Contact: "9999999999",
                Address: [
                    {
                        PAddr: "Test Address",
                        LAddr: "Test Local Address"
                    }
                ]
            }
        }
    });
}
db.Employee.bulkWrite(bulkOps)

// Test search without index
let startTime = new Date();
db.Employee.find({ Emp_id: 5000 }).explain("executionStats");
let endTime = new Date();
print("Time without index: " + (endTime - startTime) + "ms");

// Create index on Emp_id
db.Employee.createIndex({ Emp_id: 1 })

// Test search with index
startTime = new Date();
db.Employee.find({ Emp_id: 5000 }).explain("executionStats");
endTime = new Date();
print("Time with index: " + (endTime - startTime) + "ms");

// Question 7: List all indexes
db.Employee.getIndexes()

//clean up
db.Employee.dropIndex({ Designation: 1 })
db.Employee.dropIndex({ Expertise: 1 })
db.Employee.dropIndex({ Emp_id: 1 })
db.dropCollection("Employee")
db.Employee.drop()



db.createCollection("Employee")

db.Employee.insertMany([
    {
        Emp_id: 1001,
        Name: {
            FName: "Rahul",
            LName: "Sharma"
        },
        CompanyName: "Infosys",
        Salary: 65000,
        Designation: "Developer",
        Age: 28,
        Expertise: ["Java", "Spring", "MongoDB"],
        DOB: "1997-05-15",
        EmailId: "rahul.sharma@infosys.com",
        Contact: "9876543210",
        Address: [
            {
                PAddr: "Koregaon Park, Pune",
                LAddr: "Marine Drive, Mumbai"
            }
        ]
    },
    {
        Emp_id: 1002,
        Name: {
            FName: "Priya",
            LName: "Patel"
        },
        CompanyName: "TCS",
        Salary: 55000,
        Designation: "Tester",
        Age: 26,
        Expertise: ["Selenium", "Python", "TestNG"],
        DOB: "1999-08-20",
        EmailId: "priya.patel@tcs.com",
        Contact: "9876543211",
        Address: [
            {
                PAddr: "FC Road, Pune",
                LAddr: "Bandra West, Mumbai"
            }
        ]
    },
    {
        Emp_id: 1003,
        Name: {
            FName: "Amit",
            LName: "Verma"
        },
        CompanyName: "Infosys",
        Salary: 75000,
        Designation: "Tech Lead",
        Age: 32,
        Expertise: ["React", "Node.js", "AWS"],
        DOB: "1993-11-10",
        EmailId: "amit.verma@infosys.com",
        Contact: "9876543212",
        Address: [
            {
                PAddr: "Viman Nagar, Pune",
                LAddr: "Powai, Mumbai"
            }
        ]
    },
    {
        Emp_id: 1004,
        Name: {
            FName: "Sneha",
            LName: "Kumar"
        },
        CompanyName: "TCS",
        Salary: 45000,
        Designation: "Developer",
        Age: 24,
        Expertise: ["JavaScript", "React", "MongoDB"],
        DOB: "2001-03-25",
        EmailId: "sneha.kumar@tcs.com",
        Contact: "9876543213",
        Address: [
            {
                PAddr: "Kothrud, Pune",
                LAddr: "Andheri East, Mumbai"
            }
        ]
    },
    {
        Emp_id: 1005,
        Name: {
            FName: "Vikas",
            LName: "Singh"
        },
        CompanyName: "Infosys",
        Salary: 85000,
        Designation: "Solution Architect",
        Age: 35,
        Expertise: ["Java", "Kubernetes", "Azure"],
        DOB: "1990-12-05",
        EmailId: "vikas.singh@infosys.com",
        Contact: "9876543214",
        Address: [
            {
                PAddr: "Hadapsar, Pune",
                LAddr: "Juhu, Mumbai"
            }
        ]
    }
])

// Question 1 
db.Employee.find({
    Age: { $lt: 30 },
    Salary: { $gt: 50000 }
})

// Question 2 
db.Employee.updateOne(
    {
        Designation: "Tester",
        CompanyName: "TCS",
        Age: 25
    },
    {
        $setOnInsert: {
            Emp_id: 1006,
            Name: {
                FName: "Neha",
                LName: "Reddy"
            },
            Salary: 48000,
            Expertise: ["Manual Testing", "Automation", "JMeter"],
            DOB: "2000-06-15",
            EmailId: "neha.reddy@tcs.com",
            Contact: "9876543215",
            Address: [
                {
                    PAddr: "Shivaji Nagar, Pune",
                    LAddr: "Colaba, Mumbai"
                }
            ]
        }
    },
    { upsert: true }
)

// Question 3 
db.Employee.find({
    $or: [
        { Age: { $lt: 30 } },
        { Salary: { $gt: 40000 } }
    ]
})

// Question 4 
db.Employee.find({
    Designation: { $ne: "Developer" }
})

// Question 5
db.Employee.find(
    { CompanyName: "Infosys" },
    {
        _id: 1,
        Designation: 1,
        Address: 1,
        "Name.FName": 1,
        "Name.LName": 1
    }
)

// Question 6
db.Employee.find(
    {},
    {
        "Name.FName": 1,
        "Name.LName": 1,
        _id: 0
    }
)
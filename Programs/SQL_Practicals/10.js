db.createCollection("Employee")

db.Employee.insertMany([
    {
        Name: { FName: "Rahul", LName: "Sharma" },
        CompanyName: "TCS",
        Salary: 85000,
        Designation: "Programmer",
        Age: 28,
        Expertise: ["Java", "Python", "MongoDB"],
        DOB: "1997-05-15",
        EmailId: "rahul.sharma@tcs.com",
        Contact: "9876543210",
        Address: [
            { PAddr: "FC Road, Pune", LAddr: "Andheri, Mumbai" }
        ]
    },
    {
        Name: { FName: "Priya", LName: "Patel" },
        CompanyName: "Infosys",
        Salary: 75000,
        Designation: "Tester",
        Age: 32,
        Expertise: ["MongoDB", "MySQL", "Cassandra"],
        DOB: "1993-08-20",
        EmailId: "priya.patel@infosys.com",
        Contact: "9876543211",
        Address: [
            { PAddr: "Shivaji Nagar, Pune", LAddr: "Tech Park, Bangalore" }
        ]
    },
    {
        Name: { FName: "Amit", LName: "Kumar" },
        CompanyName: "TCS",
        Salary: 95000,
        Designation: "Programmer",
        Age: 30,
        Expertise: ["JavaScript", "React", "Node.js"],
        DOB: "1995-03-10",
        EmailId: "amit.kumar@tcs.com",
        Contact: "9876543212",
        Address: [
            { PAddr: "Pitampura, New Delhi", LAddr: "Baner, Pune" }
        ]
    },
    {
        Name: { FName: "Sneha", LName: "Verma" },
        CompanyName: "Infosys",
        Salary: 80000,
        Designation: "Programmer",
        Age: 27,
        Expertise: ["Python", "Django", "PostgreSQL"],
        DOB: "1998-12-25",
        EmailId: "sneha.verma@infosys.com",
        Contact: "9876543213",
        Address: [
            { PAddr: "Santa Cruz, Mumbai", LAddr: "Vagtor, Goa" }
        ]
    },
    {
        Name: { FName: "Raj", LName: "Singh" },
        CompanyName: "TCS",
        Salary: 70000,
        Designation: "Tester",
        Age: 29,
        Expertise: ["Selenium", "Java", "TestNG"],
        DOB: "1996-07-30",
        EmailId: "raj.singh@tcs.com",
        Contact: "9876543214",
        Address: [
            { PAddr: "Kothrud, Pune", LAddr: "Nashik" }
        ]
    }
])

// Question 1
db.Employee.find({
    Designation: "Programmer",
    Salary: { $gt: 30000 }
})

// Question
db.Employee.updateOne(
    {
        Designation: "Tester",
        CompanyName: "TCS",
        Age: 25
    },
    {
        $setOnInsert: {
            Name: { FName: "Anisha", LName: "Gupta" },
            Salary: 65000,
            Expertise: ["Testing", "Automation", "Selenium"],
            DOB: "2000-01-15",
            EmailId: "anisha.gupta@tcs.com",
            Contact: "9876543215",
            Address: [
                { PAddr: "Nanded City, Pune", LAddr: "High Street, Mumbai" }
            ]
        }
    },
    { upsert: true }
)

// Question 3
db.Employee.updateMany(
    { CompanyName: "Infosys" },
    { $inc: { Salary: 10000 } }
)

// Question 4
db.Employee.updateMany(
    { CompanyName: "TCS" },
    { $inc: { Salary: -5000 } }
)

// Question 5
db.Employee.find({
    Designation: { $ne: "Tester" }
})

// Quetion 6
db.Employee.find({
    Expertise: ["MongoDB", "MySQL", "Cassandra"]
})

//cleanup
db.Employee.drop()

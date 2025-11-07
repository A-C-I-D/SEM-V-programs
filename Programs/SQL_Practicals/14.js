db.createCollection("Employee")

db.Employee.insertMany([
    {
        Name: {
            FName: "Aditya",
            LName: "Sharma"
        },
        CompanyName: "Infosys",
        Salary: 85000,
        Designation: "Senior Developer",
        Age: 30,
        Expertise: ["Java", "Spring Boot", "MongoDB"],
        DOB: "1995-06-15",
        EmailId: "aditya.sharma@infosys.com",
        Contact: "9876543240",
        Address: [
            {
                PAddr: "Koregaon Park, Pune",
                LAddr: "Bandra, Mumbai"
            }
        ]
    },
    {
        Name: {
            FName: "Ananya",
            LName: "Patel"
        },
        CompanyName: "TCS",
        Salary: 95000,
        Designation: "Solution Architect",
        Age: 32,
        Expertise: ["AWS", "Azure", "Kubernetes"],
        DOB: "1993-08-20",
        EmailId: "ananya.patel@tcs.com",
        Contact: "9876543241",
        Address: [
            {
                PAddr: "Viman Nagar, Pune",
                LAddr: "Andheri, Mumbai"
            }
        ]
    },
    {
        Name: {
            FName: "Rajat",
            LName: "Verma"
        },
        CompanyName: "Infosys",
        Salary: 75000,
        Designation: "Developer",
        Age: 27,
        Expertise: ["React", "Node.js", "MongoDB"],
        DOB: "1998-11-10",
        EmailId: "rajat.verma@infosys.com",
        Contact: "9876543242",
        Address: [
            {
                PAddr: "Kothrud, Pune",
                LAddr: "Powai, Mumbai"
            }
        ]
    },
    {
        Name: {
            FName: "Kavita",
            LName: "Mishra"
        },
        CompanyName: "TCS",
        Salary: 115000,
        Designation: "Technical Lead",
        Age: 34,
        Expertise: ["Java", "Microservices", "Docker"],
        DOB: "1991-03-25",
        EmailId: "kavita.mishra@tcs.com",
        Contact: "9876543243",
        Address: [
            {
                PAddr: "Hadapsar, Pune",
                LAddr: "Malad, Mumbai"
            }
        ]
    },
    {
        Name: {
            FName: "Varun",
            LName: "Reddy"
        },
        CompanyName: "Wipro",
        Salary: 90000,
        Designation: "Senior Developer",
        Age: 31,
        Expertise: ["Python", "Django", "AWS"],
        DOB: "1994-12-05",
        EmailId: "varun.reddy@wipro.com",
        Contact: "9876543244",
        Address: [
            {
                PAddr: "Baner, Pune",
                LAddr: "Juhu, Mumbai"
            }
        ]
    }
])

// Question 1
var mapSalaryCompany = function() {
    emit(this.CompanyName, this.Salary);
};
var reduceSalary = function(key, values) {
    return Array.sum(values);
};
db.Employee.mapReduce(
    mapSalaryCompany,
    reduceSalary,
    { out: "total_salary_per_company" }
);
printjson(db.total_salary_per_company.find().toArray());

// Question 2
db.Employee.mapReduce(
    function() {
        if (this.CompanyName === "TCS") emit(this.CompanyName, this.Salary);
    },
    reduceSalary,
    { out: "total_salary_tcs" }
);
printjson(db.total_salary_tcs.find().toArray());

// Question 3.
printjson(
    db.Employee.aggregate([
        { $unwind: "$Address" },
        { $match: { "Address.PAddr": { $regex: "Pune" } } },
        { $group: { _id: "$CompanyName", avgSalary: { $avg: "$Salary" } } }
    ]).toArray()
);

//Question 4
printjson(
    db.Employee.aggregate([
        { $unwind: "$Address" },
        { $match: { "Address.PAddr": { $regex: "Pune" } } },
        { $count: "totalCount" }
    ]).toArray()
);

// Question 5
printjson(
    db.Employee.aggregate([
        { $unwind: "$Address" },
        { $match: { "Address.PAddr": { $regex: "Pune" }, Age: { $gt: 40 } } },
        { $count: "count" }
    ]).toArray()
);


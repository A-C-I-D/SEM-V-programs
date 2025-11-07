db.createCollection("Employee");

db.Employee.insertMany([
  {
    Emp_id: 3001,
    Name: {
      FName: "Kiran",
      LName: "Shah",
    },
    CompanyName: "Infosys",
    Salary: 95000,
    Designation: "Full Stack Developer",
    Age: 29,
    Expertise: ["React", "Node.js", "MongoDB", "AWS"],
    DOB: "1996-05-15",
    EmailId: "kiran.shah@infosys.com",
    Contact: "9876543230",
    Address: [
      {
        PAddr: "Wakad, Pune",
        LAddr: "Santacruz, Mumbai",
      },
    ],
  },
  {
    Emp_id: 3002,
    Name: {
      FName: "Neha",
      LName: "Joshi",
    },
    CompanyName: "TCS",
    Salary: 125000,
    Designation: "Technical Architect",
    Age: 34,
    Expertise: ["Java", "Spring", "Kubernetes", "Azure"],
    DOB: "1991-08-20",
    EmailId: "neha.joshi@tcs.com",
    Contact: "9876543231",
    Address: [
      {
        PAddr: "Kharadi, Pune",
        LAddr: "Goregaon, Mumbai",
      },
    ],
  },
  {
    Emp_id: 3003,
    Name: {
      FName: "Arjun",
      LName: "Mehta",
    },
    CompanyName: "Wipro",
    Salary: 85000,
    Designation: "Backend Developer",
    Age: 27,
    Expertise: ["Python", "Django", "PostgreSQL", "Docker"],
    DOB: "1998-11-10",
    EmailId: "arjun.mehta@wipro.com",
    Contact: "9876543232",
    Address: [
      {
        PAddr: "Bavdhan, Pune",
        LAddr: "Vashi, Mumbai",
      },
    ],
  },
  {
    Emp_id: 3004,
    Name: {
      FName: "Pooja",
      LName: "Gupta",
    },
    CompanyName: "TCS",
    Salary: 110000,
    Designation: "DevOps Engineer",
    Age: 31,
    Expertise: ["AWS", "Docker", "Jenkins", "Terraform"],
    DOB: "1994-03-25",
    EmailId: "pooja.gupta@tcs.com",
    Contact: "9876543233",
    Address: [
      {
        PAddr: "Pimpri, Pune",
        LAddr: "Kandivali, Mumbai",
      },
    ],
  },
  {
    Emp_id: 3005,
    Name: {
      FName: "Rohan",
      LName: "Kapoor",
    },
    CompanyName: "Infosys",
    Salary: 105000,
    Designation: "Full Stack Developer",
    Age: 30,
    Expertise: ["Angular", "Node.js", "MongoDB", "Redis"],
    DOB: "1995-12-05",
    EmailId: "rohan.kapoor@infosys.com",
    Contact: "9876543234",
    Address: [
      {
        PAddr: "Hadapsar, Pune",
        LAddr: "Kurla, Mumbai",
      },
    ],
  },
  {
    Emp_id: 3006,
    Name: { 
        FName: "Amit", 
        LName: "Kulkarni" 
    },
    CompanyName: "TCS",
    Salary: 95000,
    Designation: "DBA",
    Age: 32,
    Expertise: ["Oracle", "MySQL", "PostgreSQL"],
    DOB: "1992-06-15",
    EmailId: "amit.kulkarni@tcs.com",
    Contact: "9876543235",
    Address: [
        { 
            PAddr: "Viman Nagar, Pune", 
            LAddr: "Thane, Mumbai" 
        }
    ],
  },
  {
    Emp_id: 3007,
    Name: { 
        FName: "Swapnil", 
        LName: "Jadhav" 
    },
    CompanyName: "Infosys",
    Salary: 100000,
    Designation: "Backend Developer",
    Age: 28,
    Expertise: ["MongoDB", "Express", "Node.js", "React"],
    DOB: "1995-09-10",
    EmailId: "swapnil.jadhav@infosys.com",
    Contact: "9876543236",
    Address: [
        { 
            PAddr: "Shivaji Nagar, Pune", 
            LAddr: "Borivali, Mumbai" 
        }
    ],
  },
]);

// Question 1
var q1Result = db.Employee.aggregate([
  { $unwind: "$Expertise" },
  {
    $group: {
      _id: "$Expertise",
      count: { $sum: 1 },
    },
  },
  {
    $sort: { count: -1 },
  },
]);

printjson(q1Result.toArray());

// Question 2
var q2Result = db.Employee.aggregate([
  {
    $group: {
      _id: "$CompanyName",
      maxSalary: { $max: "$Salary" },
      minSalary: { $min: "$Salary" },
      avgSalary: { $avg: "$Salary" },
    },
  },
  {
    $sort: { _id: 1 },
  },
]);
printjson(q2Result.toArray());
// Question 3
var q3Result = db.Employee.aggregate([
  { $match: { Designation: "DBA" } },
  { $unwind: "$Address" },
  { $group: { _id: "$Address.PAddr", totalSalary: { $sum: "$Salary" } } },
]).toArray();
printjson(q3Result);

// Question 4
var q4Result = db.Employee.aggregate([
  { $match: { "Name.FName": "Swapnil", "Name.LName": "Jadhav" } },
  { $unwind: "$Expertise" },
  { $group: { _id: "$Emp_id", expertise: { $push: "$Expertise" } } },
]).toArray();
printjson(q4Result);

// Question 5
var q5Result = db.Employee.createIndex({
  "Name.FName": 1,
  "Name.LName": 1,
  Age: -1,
});
printjson(q5Result);

// Question 6
let bulkOps = [];
for (let i = 3008; i <= 13007; i++) {
  bulkOps.push({
    insertOne: {
      document: {
        Emp_id: i,
        Name: { FName: "Test", LName: "Employee" + i },
        CompanyName: "TestCompany",
        Salary: 50000,
        Designation: "Developer",
        Age: 25,
        Expertise: ["Java"],
        DOB: "2000-01-01",
        EmailId: `test${i}@test.com`,
        Contact: "9999999999",
        Address: [{ PAddr: "Test Address", LAddr: "Test Local Address" }],
      },
    },
  });
}
db.Employee.bulkWrite(bulkOps);

print("\nOutput for Question 6 - Index performance comparison:");
// Search without index
let startTime = new Date();
var withoutIndexStats = db.Employee.find({ Emp_id: 5000 }).explain(
  "executionStats"
);
let endTime = new Date();
print("Time without index: " + (endTime - startTime) + "ms");
print("Execution stats without index:");
printjson(withoutIndexStats.executionStats);

// Create index on Emp_id
db.Employee.createIndex({ Emp_id: 1 });

// Search with index
startTime = new Date();
var withIndexStats = db.Employee.find({ Emp_id: 5000 }).explain(
  "executionStats"
);
endTime = new Date();
print("Time with index: " + (endTime - startTime) + "ms");
print("Execution stats with index:");
printjson(withIndexStats.executionStats);

// Question 7
var q7Result = db.Employee.getIndexes();
printjson(q7Result);

//clean up
db.Employee.drop();

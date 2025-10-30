Atlas atlas-msx21u-shard-0 [primary] Empdb> db.Employee.mapReduce(
    function() {
        emit(this.Company_name, this.Salary);
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        out: "total_salary_per_company"
    }

)
{ "acknowledged" : true, "result" : "total_salary_per_company" }

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.total_salary_per_company.find()

[
  { "_id": "TCS", "value": 393000 },
  { "_id": "Infosys", "value": 348000 },
  { "_id": "Wipro", "value": 161000 },
  { "_id": "Cognizant", "value": 120000 }
]

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.Employee.mapReduce(
    function() {
        if(this.Company_name == "TCS") {
            emit(this.Company_name, this.Salary);
        }
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        out: "tcs_total_salary"
    }
)

{ "acknowledged" : true, "result" : "tcs_total_salary" }

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.tcs_total_salary.find()

[
  { "_id": "TCS", "value": 393000 }
]

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.Employee.mapReduce(
    function() {
        this.Address.forEach(function(addr) {
            if(addr.PAddr.city == "Pune") {
                emit("Pune", { sum: this.Salary, count: 1 });
            }
        }, this);
    },
    function(key, values) {
        var total = 0;
        var count = 0;
        values.forEach(function(value) {
            total += value.sum;
            count += value.count;
        });
        return { sum: total, count: count, avg: total / count };
    },
    {
        out: "pune_avg_salary"
    }
)

{ "acknowledged" : true, "result" : "pune_avg_salary" }

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.pune_avg_salary.find()

[
  { 
    "_id": "Pune", 
    "value": { 
      "sum": 444000, 
      "count": 5, 
      "avg": 88800 
    } 
  }
]

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.Employee.mapReduce(
    function() {
        if(this.Company_name == "Infosys") {
            emit(this.Designation, this.Salary);
        }
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        out: "infosys_designation_salary"
    }
)

{ "acknowledged" : true, "result" : "infosys_designation_salary" }

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.infosys_designation_salary.find()

[
  { "_id": "Developer", "value": 275000 },
  { "_id": "DBA", "value": 73000 }
]

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.Employee.mapReduce(
    function() {
        this.Address.forEach(function(addr) {
            if(addr.PAddr.State == "AP") {
                emit("AP", 1);
            }
        }, this);
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        out: "state_ap_count"
    }
)

{ "acknowledged" : true, "result" : "state_ap_count" }

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.state_ap_count.find()

[]

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.Employee.mapReduce(
    function() {
        if(this.Age > 40) {
            this.Address.forEach(function(addr) {
                if(addr.PAddr.State == "AP") {
                    emit("AP", 1);
                }
            }, this);
        }
    },
    function(key, values) {
        return Array.sum(values);
    },
    {
        out: "state_ap_age_count"
    }
)

{ "acknowledged" : true, "result" : "state_ap_age_count" }

Atlas atlas-msx21u-shard-0 [primary] Empdb>db.state_ap_age_count.find()

[]
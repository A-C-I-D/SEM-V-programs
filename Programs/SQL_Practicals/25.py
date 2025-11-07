from pymongo import MongoClient
from bson.objectid import ObjectId

class MongoDBConnection:
    def __init__(self, host='localhost', port=27017, db_name='test_db'):
        self.client = MongoClient(host, port)
        self.db = self.client[db_name]
        self.collection = self.db['employees']

    def create_employee(self, employee_data):
        """Create a new employee record"""
        try:
            result = self.collection.insert_one(employee_data)
            print(f"Employee created with ID: {result.inserted_id}")
            return result.inserted_id
        except Exception as e:
            print(f"Error creating employee: {e}")
            return None

    def read_employee(self, query=None):
        """Read employee records based on query"""
        try:
            if query is None:
                employees = self.collection.find()
            else:
                employees = self.collection.find(query)
            
            for employee in employees:
                print(employee)
        except Exception as e:
            print(f"Error reading employees: {e}")

    def update_employee(self, employee_id, update_data):
        """Update an employee record"""
        try:
            result = self.collection.update_one(
                {'_id': ObjectId(employee_id)},
                {'$set': update_data}
            )
            print(f"Modified {result.modified_count} document(s)")
            return result.modified_count
        except Exception as e:
            print(f"Error updating employee: {e}")
            return 0

    def delete_employee(self, employee_id):
        """Delete an employee record"""
        try:
            result = self.collection.delete_one({'_id': ObjectId(employee_id)})
            print(f"Deleted {result.deleted_count} document(s)")
            return result.deleted_count
        except Exception as e:
            print(f"Error deleting employee: {e}")
            return 0

def main():
    mongo_conn = MongoDBConnection()

    print("\n=== Creating Employees ===")
    employee1 = {
        "name": {
            "first": "Rahul",
            "last": "Sharma"
        },
        "email": "rahul.sharma@example.com",
        "department": "IT",
        "salary": 75000
    }
    
    employee2 = {
        "name": {
            "first": "Priya",
            "last": "Patel"
        },
        "email": "priya.patel@example.com",
        "department": "HR",
        "salary": 65000
    }

    emp1_id = mongo_conn.create_employee(employee1)
    emp2_id = mongo_conn.create_employee(employee2)

    print("\n=== Reading All Employees ===")
    mongo_conn.read_employee()

    print("\n=== Reading IT Department Employees ===")
    mongo_conn.read_employee({"department": "IT"})

    print("\n=== Updating Employee ===")
    update_data = {
        "salary": 80000,
        "department": "IT Management"
    }
    mongo_conn.update_employee(emp1_id, update_data)

    print("\n=== Verifying Update ===")
    mongo_conn.read_employee({"_id": ObjectId(emp1_id)})

    print("\n=== Deleting Employee ===")
    mongo_conn.delete_employee(emp2_id)

    print("\n=== Final Employee List ===")
    mongo_conn.read_employee()

if __name__ == "__main__":
    main()
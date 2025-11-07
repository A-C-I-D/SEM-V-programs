import mysql.connector
from mysql.connector import Error

class MySQLConnection:
    def __init__(self, host='localhost', user='root', password='root', database='test_db'):
        try:
            self.connection = mysql.connector.connect(
                host=host,
                user=user,
                password=password,
                database=database
            )
            if self.connection.is_connected():
                print("Connected to MySQL database")
                self.cursor = self.connection.cursor()
        except Error as e:
            print(f"Error connecting to MySQL: {e}")

    def create_tables(self):
        """Create required tables if they don't exist"""
        try:
            create_table_query = """
            CREATE TABLE IF NOT EXISTS employees (
                id INT AUTO_INCREMENT PRIMARY KEY,
                first_name VARCHAR(100) NOT NULL,
                last_name VARCHAR(100) NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                department VARCHAR(100) NOT NULL,
                salary DECIMAL(10, 2) NOT NULL
            )
            """
            self.cursor.execute(create_table_query)
            self.connection.commit()
            print("Tables created successfully")
        except Error as e:
            print(f"Error creating tables: {e}")

    def create_employee(self, first_name, last_name, email, department, salary):
        """Create a new employee record"""
        try:
            insert_query = """
            INSERT INTO employees (first_name, last_name, email, department, salary)
            VALUES (%s, %s, %s, %s, %s)
            """
            record = (first_name, last_name, email, department, salary)
            self.cursor.execute(insert_query, record)
            self.connection.commit()
            print("Employee created successfully")
            return self.cursor.lastrowid
        except Error as e:
            print(f"Error creating employee: {e}")
            return None

    def read_employees(self, condition=None):
        """Read employee records based on condition"""
        try:
            if condition:
                query = f"SELECT * FROM employees WHERE {condition}"
            else:
                query = "SELECT * FROM employees"
            
            self.cursor.execute(query)
            records = self.cursor.fetchall()
            
            for row in records:
                print(f"ID: {row[0]}")
                print(f"Name: {row[1]} {row[2]}")
                print(f"Email: {row[3]}")
                print(f"Department: {row[4]}")
                print(f"Salary: {row[5]}")
                print("-" * 30)
                
            return records
        except Error as e:
            print(f"Error reading employees: {e}")
            return []

    def update_employee(self, employee_id, **kwargs):
        """Update an employee record"""
        try:
            update_parts = []
            values = []
            for key, value in kwargs.items():
                update_parts.append(f"{key} = %s")
                values.append(value)
            values.append(employee_id)

            update_query = f"""
            UPDATE employees 
            SET {', '.join(update_parts)}
            WHERE id = %s
            """
            
            self.cursor.execute(update_query, values)
            self.connection.commit()
            print("Employee updated successfully")
            return self.cursor.rowcount
        except Error as e:
            print(f"Error updating employee: {e}")
            return 0

    def delete_employee(self, employee_id):
        """Delete an employee record"""
        try:
            delete_query = "DELETE FROM employees WHERE id = %s"
            self.cursor.execute(delete_query, (employee_id,))
            self.connection.commit()
            print("Employee deleted successfully")
            return self.cursor.rowcount
        except Error as e:
            print(f"Error deleting employee: {e}")
            return 0

    def close_connection(self):
        """Close the database connection"""
        if self.connection.is_connected():
            self.cursor.close()
            self.connection.close()
            print("MySQL connection closed")

def main():
    # Create MySQL connection
    mysql_conn = MySQLConnection()
    mysql_conn.create_tables()

    print("\n=== Creating Employees ===")
    emp1_id = mysql_conn.create_employee(
        "Amit", "Kumar", 
        "amit.kumar@example.com",
        "IT",
        70000
    )

    emp2_id = mysql_conn.create_employee(
        "Sneha", "Verma",
        "sneha.verma@example.com",
        "HR",
        65000
    )

    print("\n=== Reading All Employees ===")
    mysql_conn.read_employees()

    print("\n=== Reading IT Department Employees ===")
    mysql_conn.read_employees("department = 'IT'")

    print("\n=== Updating Employee ===")
    mysql_conn.update_employee(
        emp1_id,
        department="IT Management",
        salary=75000
    )

    print("\n=== Verifying Update ===")
    mysql_conn.read_employees(f"id = {emp1_id}")

    print("\n=== Deleting Employee ===")
    mysql_conn.delete_employee(emp2_id)

    print("\n=== Final Employee List ===")
    mysql_conn.read_employees()

    mysql_conn.close_connection()

if __name__ == "__main__":
    main()
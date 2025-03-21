from werkzeug.security import generate_password_hash
import mysql.connector

def update_tutor_passwords():
    hashed_password = generate_password_hash('password')

    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Fathimaharis@1",
        database="tutoreal"
    )

    cursor = conn.cursor()

    hashed_password_query = """
        UPDATE Tutors
        SET password = %s
        WHERE tutor_id BETWEEN 1 AND 50;
    """

    cursor.execute(hashed_password_query, (hashed_password,))
    conn.commit()
    cursor.close()
    conn.close()

if __name__ == "__main__":
    update_tutor_passwords()
    print("Tutor passwords updated successfully!")

def update_student_passwords():
    hashed_password = generate_password_hash('password')

    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Fathimaharis@1",
        database="tutoreal"
    )

    cursor = conn.cursor()

    hashed_password_query = """
        UPDATE Students
        SET password = %s
        WHERE student_id BETWEEN 1 AND 50;
    """

    cursor = conn.cursor()
    cursor.execute(hashed_password_query, (hashed_password,))
    conn.commit()
    cursor.close()
    conn.close()

if __name__ == "__main__":
    update_student_passwords()
    print("Passwords updated successfully!")


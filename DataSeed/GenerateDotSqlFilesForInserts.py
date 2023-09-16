# -*- coding: utf-8 -*-
"""
Created on Sat Sep 16

@author: Karam
"""

from faker import Faker
import random 
from datetime import datetime, timedelta
from typing import List, Dict
import uuid
import os

fake = Faker()

status_options = ["Available", "Borrowed"]

genres = ["Science Fiction", "Mystery", "Fantasy", 
          "Romance", "Thriller", "Biography", 
          "Historical Fiction", "Horror", "Comedy", 
          "Drama"]
shelves =  [f"Shelf-{i}" for i in range(0, 260, 4)]

def create_books(number_of_books: int) -> Dict[str, List[str]]:
    book_data = {
        'BookID': [],
        'Title': [],
        'ISBN': [],
        'PublishDate': [],
        'CurrentStatus': [],
        'Author': [],
        'Genre': [],
        'ShelfLocation': []
    }
    
    for _ in range(number_of_books):
        book_id = str(uuid.uuid4())
        title = fake.catch_phrase()
        isbn = fake.isbn13()
        publish_date = fake.date_between(start_date='-120y', end_date='today').strftime('%Y-%m-%d')
        status = random.choice(status_options)
        author = fake.name()
        genre = random.choice(genres)
        shelf_location = random.choice(shelves)
        
        
        book_data['BookID'].append(book_id)
        book_data['Title'].append(title)
        book_data['ISBN'].append(isbn)
        book_data['PublishDate'].append(publish_date)
        book_data['CurrentStatus'].append(status)
        book_data['Author'].append(author)
        book_data['Genre'].append(genre)
        book_data['ShelfLocation'].append(shelf_location)
    
    return book_data

def create_borrowers(number_of_borrowers: int) -> Dict[str, List[str]]:
    borrowers = {
        'BorrowerID': [],
        'FirstName': [],
        'LastName': [],
        'Email': [],
        'DOB': [],
        'MemberSince': []
        }
    
    for _ in range(number_of_borrowers):
        borrower_id = str(uuid.uuid4())
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = fake.email()
        dob = fake.date_between(start_date='-80y', end_date='today').strftime('%Y-%m-%d')
        member_since = fake.date_between(start_date='-15y', end_date='today').strftime('%Y-%m-%d')
        
        
        borrowers['BorrowerID'].append(borrower_id)
        borrowers['FirstName'].append(first_name)
        borrowers['LastName'].append(last_name)
        borrowers['Email'].append(email)
        borrowers['DOB'].append(dob)
        borrowers['MemberSince'].append(member_since)
        
    return borrowers  

def create_loans(books: List[str], borrowers: List[str], number_of_loans: int) -> List[str]:
    loans = {
        'BookID': [],
        'BorrowerID': [],
        'DateBorrowed': [],
        'DueDate': [],
        'DateReturned': []
        }

    for _ in range(number_of_loans):
        loaned_book = random.choice(books['BookID'])
        borrower = random.choice(borrowers['BorrowerID'])
        
        yesterday = datetime.now() - timedelta(days=1)
        date_borrowed = fake.date_between(
            start_date ='-15y', 
            end_date = yesterday).strftime('%Y-%m-%d')
        
        three_weeks = datetime.now() + timedelta(days= 21)
        due_date = fake.date_between(
            start_date = datetime.strptime(date_borrowed, '%Y-%m-%d'),
            end_date = three_weeks
            )
        
        date_returned = fake.date_between(
            start_date = datetime.strptime(date_borrowed, '%Y-%m-%d'),
            end_date = 'today')
        
        date_returned = random.choices(
            [date_returned, None], 
            weights = [0.65, 0.35])[0]
        
        loans['BookID'].append(loaned_book)
        loans['BorrowerID'].append(borrower)
        loans['DateBorrowed'].append(date_borrowed)
        loans['DueDate'].append(due_date)
        loans['DateReturned'].append(date_returned)
        
    return loans

def book_to_sql_insert(books: Dict[str, List[str]]
                       ) -> List[str]:
    sql_inserts = []

    for i in range(len(books['BookID'])):
        book_id = books['BookID'][i]
        title = books['Title'][i]
        isbn = books['ISBN'][i]
        publish_date = books['PublishDate'][i]
        status = books['CurrentStatus'][i]
        author = books['Author'][i]
        genre = books['Genre'][i]
        shelf_location = books['ShelfLocation'][i]

        sql_insert = f"INSERT INTO Books (BookID, Title, ISBN, PublishDate, CurrentStatus, Author, Genre, ShelfLocation) " \
                     f"VALUES ('{book_id}', '{title}', '{isbn}', '{publish_date}', '{status}', '{author}', '{genre}', '{shelf_location}')"

        sql_inserts.append(sql_insert)

    return sql_inserts

def borrower_to_sql_insert(borrowers: Dict[str, List[str]]) -> List[str]:
    sql_inserts = []
    
    for i in range(len(borrowers['BorrowerID'])):
        borrower_id = borrowers['BorrowerID'][i]
        first_name =  borrowers['FirstName'][i]
        last_name = borrowers['LastName'][i]
        email = borrowers['Email'][i]
        dob = borrowers['DOB'][i]
        member_since = borrowers['MemberSince'][i]
        
        sql_insert = f"INSERT INTO Borrowers (BorrowerID, FirstName, LastName, Email, DateOfBirth, MemberSince) " \
                     f"VALUES ('{borrower_id}', '{first_name}', '{last_name}', '{email}', '{dob}', '{member_since}')"
        
        sql_inserts.append(sql_insert)
        
    return sql_inserts

def loan_to_sql_insert(loans: Dict[str, List[str]]) -> List[str]:
    sql_inserts = []
    for i in range(len(loans['BookID'])):
        book_id = loans['BookID'][i]
        borrower_id = loans['BorrowerID'][i]
        date_borrowed = loans['DateBorrowed'][i]
        due_date = loans['DueDate'][i]
        date_returned = loans['DateReturned'][i]
        
        sql_insert = f"INSERT INTO Loans (BookID, BorrowerID, DateBorrowed, DueDate, DateReturned) " \
                     f"VALUES ('{book_id}', '{borrower_id}', '{date_borrowed}', '{due_date}', "
        
        sql_insert += "Null)" if date_returned is None else f"'{date_returned}')"
        sql_inserts.append(sql_insert)
        
    return sql_inserts

if __name__ == "__main__":
    
    books = create_books(1000)
    borrowers = create_borrowers(1000)
    loans = create_loans(books, borrowers, 1000)
    
    books_to_sql = book_to_sql_insert(books)
    borrowers_to_sql = borrower_to_sql_insert(borrowers)
    loans_to_sql = loan_to_sql_insert(loans)
    
    current_directory = os.getcwd()
    
    books_path = os.path.join(current_directory, "books.sql")
    with open(books_path, "w") as sql_file:
        for sql_insert in books_to_sql:
            sql_file.write(sql_insert + ";\n")
            
    borrowers_path = os.path.join(current_directory, "borrowers.sql")
    with open(borrowers_path, "w") as sql_file:
        for sql_insert in borrowers_to_sql:
            sql_file.write(sql_insert + ";\n")
    
    loans_path = os.path.join(current_directory, "loans.sql")
    with open(loans_path, "w") as sql_file:
        for sql_insert in loans_to_sql:
            sql_file.write(sql_insert + ";\n")
        
    
# DB_Project
# Developer Reflection
🔹 What part was the most difficult?
The most challenging part was ensuring referential integrity across all tables, especially when handling foreign keys with actions like ON DELETE CASCADE. Balancing real-world logic (e.g., not allowing deletion of members with active loans) with database enforcement required careful thought. The normalization process also pushed me to reconsider how data should be stored efficiently and without redundancy.

🔹 Which SQL command (DDL, DML, DQL) did you learn the most from?
I learned the most from DML. Writing complex INSERT, UPDATE, and DELETE statements in a way that respects constraints, dependencies, and data logic was highly educational. Testing real-world behavior with DML helped me understand transaction safety and user behavior more deeply.

🔹 What did you discover from your error logs that made you think like a real developer?
The error-based learning phase made me realize how every SQL constraint tells a story—a story of data safety, business rules, and user logic. For example, trying to delete a member who had written reviews or issued books reminded me how important it is to prevent accidental data loss. These logs made me think not just like a coder, but like a defensive backend engineer, anticipating user errors and safeguarding the system.

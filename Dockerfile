# Use Python as the base image
FROM python:3.10

# Set working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Install dbt and the necessary adapter
RUN pip install --no-cache-dir dbt-bigquery

# Install additional dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set the default command to run dbt
CMD ["dbt", "--help"]

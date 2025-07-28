using Microsoft.EntityFrameworkCore;
using SampleDemoCRUDApi.Models.Entities;

namespace SampleDemoCRUDApi.Data
{
    public class ApplicationDbContext:DbContext
    {
        public ApplicationDbContext(DbContextOptions options) : base(options)
        { 
        }
        public DbSet<Employee> Employee {  get; set; }
    }
}

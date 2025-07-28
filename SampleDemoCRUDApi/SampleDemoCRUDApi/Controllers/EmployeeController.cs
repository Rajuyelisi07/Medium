using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using SampleDemoCRUDApi.Data;
using SampleDemoCRUDApi.Models.Entities;

namespace SampleDemoCRUDApi.Controllers
{
    [Route("api/[controller]")]
    [EnableRateLimiting("fixed")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public EmployeeController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("/[action]")]
        //[EnableRateLimiting("fixed")]
        public IActionResult GetAllEmployees()
        {
            var Employees = _context.Employee.ToList();
            return Ok(Employees);
        }

        [HttpPost]
        [Route("/[action]")]
        //[EnableRateLimiting("fixed")]
        public IActionResult AddEmployee(Employee employee)
        {
            _context.Employee.Add(employee);
            _context.SaveChanges();
            return Ok(employee);
        }
        [HttpGet]
        [Route("/[action]")]
        [EnableRateLimiting("fixed")]
        public IActionResult GetById(Guid id)
        {
            var empdet = _context.Employee.Find(id);
            return Ok(empdet);

        }
    }
}

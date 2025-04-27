using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using PDV.API.Controllers;
using Xunit;
using FluentAssertions;
using System;

namespace PDV.Tests
{
    public class TestControllerTests
    {
        private readonly Mock<ILogger<TestController>> _loggerMock;
        private readonly TestController _controller;

        public TestControllerTests()
        {
            _loggerMock = new Mock<ILogger<TestController>>();
            _controller = new TestController(_loggerMock.Object);
        }

        [Fact]
        public void Get_ShouldReturnOkResult()
        {
            // Act
            var result = _controller.Get();

            // Assert
            result.Should().BeOfType<OkObjectResult>();
            var okResult = result as OkObjectResult;
            okResult.Should().NotBeNull();
            okResult!.Value.Should().NotBeNull();
            
            dynamic value = okResult.Value!;
            ((string)value.message).Should().Be("API is working!");
            ((DateTime)value.timestamp).Should().BeCloseTo(DateTime.UtcNow, TimeSpan.FromSeconds(5));
        }

        [Fact]
        public void GetEnvironment_ShouldReturnEnvironmentVariable()
        {
            // Act
            var result = _controller.GetEnvironment();

            // Assert
            result.Should().BeOfType<OkObjectResult>();
            var okResult = result as OkObjectResult;
            okResult.Should().NotBeNull();
            okResult!.Value.Should().NotBeNull();
        }
    }
}

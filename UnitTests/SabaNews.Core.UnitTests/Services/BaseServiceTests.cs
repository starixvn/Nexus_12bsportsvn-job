namespace SabaNews.Core.UnitTests.Services
{
    using Fanex.Data.Repository;
    using NSubstitute;
    using SabaNews.Core.Models;
    using SabaNews.Core.Repositories;
    using SabaNews.Core.Services;
    using System;
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Xunit;

    public class BaseServiceTests
    {
        private IDynamicRepository dynamicRepository;
        private IBaseRepository baseRepository;
        private ILogServiceProvider logServiceProvider;

        #region GetDataAsync

        [Fact]
        public async Task GetDataAsync_CriteriaIsNull_ReturnEmptyList()
        {
            // Arrange
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.GetDataAsync<int>(null);

            // Assert
            Assert.Empty(actual);
        }

        [Fact]
        public async Task GetDataAsync_CriteriaIsInvalid_ReturnEmptyList()
        {
            // Arrange
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(false);
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.GetDataAsync<int>(criteria);

            // Assert
            Assert.Empty(actual);
        }

        [Fact]
        public async Task GetDataAsync_CriteriaIsValid_ReturnExpectedData()
        {
            // Arrange
            var expected = new List<int> { 1, 2 };
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(true);
            var baseService = GetBaseService();
            dynamicRepository.FetchAsync<int>(criteria).Returns(expected);

            // Act
            var actual = await baseService.GetDataAsync<int>(criteria);

            // Assert
            Assert.NotEmpty(actual);
            Assert.Equal(expected, actual);
        }

        #endregion GetDataAsync

        #region GetDataEntityAsync

        [Fact]
        public async Task GetDataEntityAsync_CriteriaIsNull_ReturnDefaultValue()
        {
            // Arrange
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.GetDataEntityAsync<int>(null);

            // Assert
            Assert.Equal(0, actual);
        }

        [Fact]
        public async Task GetDataEntityAsync_CriteriaIsInvalid_ReturnDefaultValue()
        {
            // Arrange
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(false);
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.GetDataEntityAsync<int>(criteria);

            // Assert
            Assert.Equal(0, actual);
        }

        [Fact]
        public async Task GetDataEntityAsync_CriteriaIsValid_ReturnExpectedData()
        {
            // Arrange
            var expected = 1;
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(true);
            var baseService = GetBaseService();
            dynamicRepository.GetAsync<int>(criteria).Returns(expected);

            // Act
            var actual = await baseService.GetDataEntityAsync<int>(criteria);

            // Assert
            Assert.Equal(expected, actual);
        }

        #endregion GetDataEntityAsync

        #region FetchMultipleAsync

        [Fact]
        public async Task FetchMultipleAsync_CriteriaIsNull_ReturnTupleWithEmptyList()
        {
            // Arrange
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.FetchMultipleAsync<int, int>(null);

            // Assert
            Assert.Empty(actual.Item1);
            Assert.Empty(actual.Item2);
        }

        [Fact]
        public async Task FetchMultipleAsync_CriteriaIsInvalid_ReturnTupleWithEmptyList()
        {
            // Arrange
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(false);
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.FetchMultipleAsync<int, int>(criteria);

            // Assert
            Assert.Empty(actual.Item1);
            Assert.Empty(actual.Item2);
        }

        [Fact]
        public async Task FetchMultipleAsync_CriteriaIsValid_ReturnExpectedData()
        {
            // Arrange
            var expected = new ValueTuple<IEnumerable<int>, IEnumerable<int>>(new List<int> { 1, 2 }, new List<int> { 1, 2 });
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(true);
            var baseService = GetBaseService();
            dynamicRepository.FetchMultipleAsync<int, int>(criteria).Returns(expected);

            // Act
            var actual = await baseService.FetchMultipleAsync<int, int>(criteria);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact]
        public async Task FetchMultipleAsync_WithThreeDataSetCriteriaIsNull_ReturnTupleWithEmptyList()
        {
            // Arrange
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.FetchMultipleAsync<int, int, int>(null);

            // Assert
            Assert.Empty(actual.Item1);
            Assert.Empty(actual.Item2);
            Assert.Empty(actual.Item3);
        }

        [Fact]
        public async Task FetchMultipleAsync_WithThreeDataCriteriaIsInvalid_ReturnTupleWithEmptyList()
        {
            // Arrange
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(false);
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.FetchMultipleAsync<int, int, int>(criteria);

            // Assert
            Assert.Empty(actual.Item1);
            Assert.Empty(actual.Item2);
            Assert.Empty(actual.Item3);
        }

        [Fact]
        public async Task FetchMultipleAsync_WithThreeDataCriteriaIsValid_ReturnExpectedData()
        {
            // Arrange
            var expected = new ValueTuple<IEnumerable<int>, IEnumerable<int>, IEnumerable<int>>(new List<int> { 1, 2 }, new List<int> { 1, 2 }, new List<int> { 1, 2 });
            var criteria = Substitute.For<ICriteria>();
            criteria.IsValid().Returns(true);
            var baseService = GetBaseService();
            dynamicRepository.FetchMultipleAsync<int, int, int>(criteria).Returns(expected);

            // Act
            var actual = await baseService.FetchMultipleAsync<int, int, int>(criteria);

            // Assert
            Assert.Equal(expected, actual);
        }

        #endregion FetchMultipleAsync

        #region ExecuteNonQueryAsync

        [Fact]
        public async Task ExecuteNonQueryAsync_CriteriaIsNull_ReturnDefaultCommandResult()
        {
            // Arrange
            var expected = new CommandResult();
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.ExecuteNonQueryAsync(null);

            // Assert
            Assert.Equal(expected.Code, actual.Code);
            Assert.Equal(expected.IsSuccessful, actual.IsSuccessful);
            Assert.Equal(expected.Message, actual.Message);
        }

        [Fact]
        public async Task ExecuteNonQueryAsync_CriteriaIsInvalid_ReturnDefaultCommandResult()
        {
            // Arrange
            var expected = new CommandResult();
            var criteria = Substitute.For<INonQueryCommand>();
            criteria.IsValid().Returns(false);
            var baseService = GetBaseService();

            // Act
            var actual = await baseService.ExecuteNonQueryAsync(criteria);

            // Assert
            Assert.Equal(expected.Code, actual.Code);
            Assert.Equal(expected.IsSuccessful, actual.IsSuccessful);
            Assert.Equal(expected.Message, actual.Message);
        }

        [Fact]
        public async Task ExecuteNonQueryAsync_CriteriaIsValid_ExpectedExecuteQuery()
        {
            // Arrange
            var criteria = Substitute.For<INonQueryCommand>();
            criteria.IsValid().Returns(true);
            var baseService = GetBaseService();

            // Act
            await baseService.ExecuteNonQueryAsync(criteria);

            // Assert
            await baseRepository.Received().ExecuteNonQueryAsync(Arg.Is<INonQueryCommand>(x => x.IsValid()));
        }

        #endregion ExecuteNonQueryAsync

        #region Helpers

        private BaseService GetBaseService()
        {
            dynamicRepository = Substitute.For<IDynamicRepository>();
            baseRepository = Substitute.For<IBaseRepository>();
            logServiceProvider = Substitute.For<ILogServiceProvider>();
            var service = new BaseService(dynamicRepository, baseRepository, logServiceProvider);

            return service;
        }

        #endregion Helpers
    }
}

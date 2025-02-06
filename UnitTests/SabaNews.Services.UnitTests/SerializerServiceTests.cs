namespace SabaNews.Services.UnitTests
{
    using System.Collections;
    using System.Globalization;
    using System.Text;
    using AutoFixture;
    using Fanex.Logging;
    using NSubstitute;
    using Xunit;

    public class SerializerServiceTests
    {
        private ILogger logService;
        private int pos;
        private readonly Encoding stringEncoding;
        private readonly NumberFormatInfo nfi;
        private const short TwoCharacters = 2;
        private const short ThreeCharacters = 3;
        private const short FourCharacters = 4;
        private const short SixCharacters = 6;
        private readonly IFixture fixture = new Fixture();

        [Fact]
        public void GetListImageFromMetadata_WhenMetadataIsNull_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            string metadata = null;
            //Act
            var actual = service.Unserializer(metadata);

            // Assert

            Assert.Null(actual);
        }

        [Fact]
        public void GetListImageFromMetadata_WhenWrongFormarMetaData_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            string metadata = "";
            //Act
            var actual = service.Unserializer(metadata);

            // Assert

            Assert.Null(actual);
        }

        [Fact]
        public void GetListImageFromMetadata_WhenHaveMetaData_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            string metadata = "a:5:{s:5:\"width\";i:1200;s:6:\"height\";i:800;s:6:\"double\";d:800;s:4:\"file\";s:30:\"2020/08/PSG-e1596260799848.jpg\";s:5:\"sizes\";a:28:{s:6:\"medium\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-300x200.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:200;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:5:\"large\";a:4:{s:4:\"file\";s:31:\"PSG-e1596260799848-1024x683.jpg\";s:5:\"width\";i:1024;s:6:\"height\";i:683;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:9:\"thumbnail\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:12:\"medium_large\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-768x512.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:512;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:23:\"sportspress-crop-medium\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-500x500.jpg\";s:5:\"width\";i:500;s:6:\"height\";i:500;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:22:\"sportspress-fit-medium\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-500x333.jpg\";s:5:\"width\";i:500;s:6:\"height\";i:333;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:20:\"sportspress-fit-icon\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-400x267.jpg\";s:5:\"width\";i:400;s:6:\"height\";i:267;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:20:\"sportspress-fit-mini\";a:4:{s:4:\"file\";s:28:\"PSG-e1596260799848-32x21.jpg\";s:5:\"width\";i:32;s:6:\"height\";i:21;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:14:\"post-thumbnail\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-370x247.jpg\";s:5:\"width\";i:370;s:6:\"height\";i:247;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:19:\"fcunited-thumb-huge\";a:4:{s:4:\"file\";s:31:\"PSG-e1596260799848-1200x719.jpg\";s:5:\"width\";i:1200;s:6:\"height\";i:719;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:18:\"fcunited-thumb-big\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-818x461.jpg\";s:5:\"width\";i:818;s:6:\"height\";i:461;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:18:\"fcunited-thumb-med\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-406x228.jpg\";s:5:\"width\";i:406;s:6:\"height\";i:228;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:19:\"fcunited-thumb-tiny\";a:4:{s:4:\"file\";s:28:\"PSG-e1596260799848-90x90.jpg\";s:5:\"width\";i:90;s:6:\"height\";i:90;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:26:\"fcunited-thumb-masonry-big\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-818x545.jpg\";s:5:\"width\";i:818;s:6:\"height\";i:545;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:22:\"fcunited-thumb-masonry\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-406x271.jpg\";s:5:\"width\";i:406;s:6:\"height\";i:271;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:20:\"fcunited-thumb-extra\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-600x394.jpg\";s:5:\"width\";i:600;s:6:\"height\";i:394;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:24:\"fcunited-thumb-alternate\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-650x720.jpg\";s:5:\"width\";i:650;s:6:\"height\";i:720;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:21:\"fcunited-thumb-height\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-380x495.jpg\";s:5:\"width\";i:380;s:6:\"height\";i:495;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:20:\"fcunited-thumb-plain\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-260x240.jpg\";s:5:\"width\";i:260;s:6:\"height\";i:240;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:21:\"woocommerce_thumbnail\";a:5:{s:4:\"file\";s:30:\"PSG-e1596260799848-300x300.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:300;s:9:\"mime-type\";s:10:\"image/jpeg\";s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-600x400.jpg\";s:5:\"width\";i:600;s:6:\"height\";i:400;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:29:\"woocommerce_gallery_thumbnail\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:12:\"shop_catalog\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-300x300.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:300;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:11:\"shop_single\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-600x400.jpg\";s:5:\"width\";i:600;s:6:\"height\";i:400;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:14:\"shop_thumbnail\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:22:\"trx_addons-thumb-small\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-270x152.jpg\";s:5:\"width\";i:270;s:6:\"height\";i:152;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:25:\"trx_addons-thumb-portrait\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-370x493.jpg\";s:5:\"width\";i:370;s:6:\"height\";i:493;s:9:\"mime-type\";s:10:\"image/jpeg\";}s:23:\"trx_addons-thumb-avatar\";a:4:{s:4:\"file\";s:30:\"PSG-e1596260799848-370x370.jpg\";s:5:\"width\";i:370;s:6:\"height\";i:370;s:9:\"mime-type\";s:10:\"image/jpeg\";s:9:\"uncropped\";b:0;s:4:\"null\"N:2}}";
            //Act
            var actual = service.Unserializer(metadata);

            // Assert

            // Assert.Equal(28, actual.Count());
        }

        [Fact]
        public void GetListImageFromMetadata_WhenGoOnCatch_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            string metadata = "a:5:{s:40:\"0\";N:1;s:5:\"intt;\";a:1:;i:1200;";
            //Act
            var actual = service.Unserializer(metadata);

            // Assert

        }

        [Fact]
        public void GetListImageFromMetadata_HandleArrayType_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            string metadata = "a:5:{s:1:\"0\";N:1;s:5:\"intt;\";a:1:;i:1200;";
            //Act
            var actual = service.Unserializer(metadata);

            // Assert

            // Assert.Equal(new List<ImageInfo>(), actual);
        }

        [Fact]
        public void GetListImageFromMetadata_HandleTypeString_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            string metadata = "a:5:{s:5:\"11111\"";
            //Act
            var actual = service.Unserializer(metadata);

            // Assert

            // Assert.Equal(new List<ImageInfo>(), actual);
        }

        [Fact]
        public void UnserializerToArrayList_WhenCalled_ReturnExpectedData()
        {
            // Arrange
            var service = GetSerializerService();
            var arrayList = new ArrayList();
            arrayList.Add(7334);
            arrayList.Add(7332);
            string metadata = "a:2:{i:0;i:7334;i:1;i:7332;}";
            //Act
            var actual = service.UnserializerToArrayList(metadata);

            // Assert

            Assert.Equal(arrayList, actual);
        }

        #region Helpers

        private SerializerService GetSerializerService()
        {
            logService = Substitute.For<ILogger>();
            var service = new SerializerService();

            return service;
        }

        #endregion Helpers
    }
}
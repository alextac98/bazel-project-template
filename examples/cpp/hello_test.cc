#include <gtest/gtest.h>
#include <gmock/gmock.h>

TEST(HelloTest, BasicAssertion) {
    EXPECT_EQ(1 + 1, 2);
}

TEST(HelloTest, StringComparison) {
    EXPECT_THAT("Hello from C++!", ::testing::HasSubstr("C++"));
}

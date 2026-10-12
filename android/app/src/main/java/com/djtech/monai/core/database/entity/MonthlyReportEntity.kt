package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Embedded
import androidx.room3.Entity
import androidx.room3.ForeignKey
import androidx.room3.PrimaryKey
import androidx.room3.Relation
import com.djtech.monai.core.model.CategoryBreakdown
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.model.PreviousMonthTotals
import java.time.YearMonth

@Entity(tableName = "monthly_reports")
data class MonthlyReportEntity(
    @PrimaryKey
    @ColumnInfo(name = "month")
    val month: YearMonth,

    @ColumnInfo(name = "income_total")
    val incomeTotal: Long,

    @ColumnInfo(name = "expense_total")
    val expenseTotal: Long,

    @ColumnInfo(name = "net")
    val net: Long,

    @ColumnInfo(name = "previous_month")
    val previousMonth: YearMonth,

    @ColumnInfo(name = "previous_income_total")
    val previousIncomeTotal: Long,

    @ColumnInfo(name = "previous_expense_total")
    val previousExpenseTotal: Long,

    @ColumnInfo(name = "expense_change_percent")
    val expenseChangePercent: Double?,
)

/** One row of a report's expense breakdown; [position] keeps the server's order. */
@Entity(
    tableName = "report_categories",
    primaryKeys = ["month", "category_id"],
    foreignKeys = [
        ForeignKey(
            entity = MonthlyReportEntity::class,
            parentColumns = ["month"],
            childColumns = ["month"],
            onDelete = ForeignKey.CASCADE,
        ),
    ],
)
data class ReportCategoryEntity(
    @ColumnInfo(name = "month")
    val month: YearMonth,

    @ColumnInfo(name = "category_id")
    val categoryId: String,

    @ColumnInfo(name = "position")
    val position: Int,

    @ColumnInfo(name = "name")
    val name: String,

    @ColumnInfo(name = "icon")
    val icon: String?,

    @ColumnInfo(name = "color")
    val color: String?,

    @ColumnInfo(name = "amount")
    val amount: Long,

    @ColumnInfo(name = "share_percent")
    val sharePercent: Double,

    @ColumnInfo(name = "previous_amount")
    val previousAmount: Long,

    @ColumnInfo(name = "change_percent")
    val changePercent: Double?,
)

data class MonthlyReportWithCategories(
    @Embedded
    val report: MonthlyReportEntity,

    @Relation(parentColumns = ["month"], entityColumns = ["month"])
    val categories: List<ReportCategoryEntity>,
)

fun MonthlyReportWithCategories.asModel() = MonthlyReport(
    month = report.month,
    incomeTotal = report.incomeTotal,
    expenseTotal = report.expenseTotal,
    net = report.net,
    previous = PreviousMonthTotals(
        month = report.previousMonth,
        incomeTotal = report.previousIncomeTotal,
        expenseTotal = report.previousExpenseTotal,
    ),
    expenseChangePercent = report.expenseChangePercent,
    categories = categories.sortedBy { it.position }.map { it.asModel() },
)

private fun ReportCategoryEntity.asModel() = CategoryBreakdown(
    categoryId = categoryId,
    name = name,
    icon = icon,
    color = color,
    amount = amount,
    sharePercent = sharePercent,
    previousAmount = previousAmount,
    changePercent = changePercent,
)

fun MonthlyReport.asEntity() = MonthlyReportEntity(
    month = month,
    incomeTotal = incomeTotal,
    expenseTotal = expenseTotal,
    net = net,
    previousMonth = previous.month,
    previousIncomeTotal = previous.incomeTotal,
    previousExpenseTotal = previous.expenseTotal,
    expenseChangePercent = expenseChangePercent,
)

fun MonthlyReport.categoryEntities(): List<ReportCategoryEntity> =
    categories.mapIndexed { index, category ->
        ReportCategoryEntity(
            month = month,
            categoryId = category.categoryId,
            position = index,
            name = category.name,
            icon = category.icon,
            color = category.color,
            amount = category.amount,
            sharePercent = category.sharePercent,
            previousAmount = category.previousAmount,
            changePercent = category.changePercent,
        )
    }

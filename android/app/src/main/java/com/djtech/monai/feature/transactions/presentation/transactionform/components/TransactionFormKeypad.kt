package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormIntent

private sealed interface Key {
    data class Digit(val value: Int) : Key

    data object TripleZero : Key

    data object Backspace : Key
}

private val KEYS = listOf(
    listOf(Key.Digit(1), Key.Digit(2), Key.Digit(3)),
    listOf(Key.Digit(4), Key.Digit(5), Key.Digit(6)),
    listOf(Key.Digit(7), Key.Digit(8), Key.Digit(9)),
    listOf(Key.TripleZero, Key.Digit(0), Key.Backspace),
)

/** The 3×4 number pad with 52dp keys. */
@Composable
internal fun TransactionFormKeypad(onIntent: (TransactionFormIntent) -> Unit, modifier: Modifier = Modifier) {
    val gap = MonAITheme.spacing.x1_5
    Column(modifier, verticalArrangement = Arrangement.spacedBy(gap)) {
        KEYS.forEach { row ->
            Row(Modifier.height(52.dp), horizontalArrangement = Arrangement.spacedBy(gap)) {
                row.forEach { key ->
                    KeyButton(
                        key,
                        onClick = {
                            onIntent(
                                when (key) {
                                    is Key.Digit -> TransactionFormIntent.Digit(key.value)
                                    Key.TripleZero -> TransactionFormIntent.TripleZero
                                    Key.Backspace -> TransactionFormIntent.Backspace
                                },
                            )
                        },
                        modifier = Modifier.weight(1f),
                    )
                }
            }
        }
    }
}

@Composable
private fun KeyButton(key: Key, onClick: () -> Unit, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val deleteLabel = stringResource(R.string.transaction_form_delete_digit)
    Box(
        modifier
            .fillMaxHeight()
            .clip(RoundedCornerShape(MonAITheme.radius.lg))
            .background(colors.surfaceKey)
            .clickable(role = Role.Button, onClick = onClick)
            .then(if (key == Key.Backspace) Modifier.semantics { contentDescription = deleteLabel } else Modifier),
        contentAlignment = Alignment.Center,
    ) {
        when (key) {
            Key.Backspace -> Icon(MonAIIcons.Backspace, null, tint = colors.textPrimary)
            else -> Text(
                if (key is Key.Digit) key.value.toString() else "000",
                style = MonAITheme.typography.headlineSmall.copy(
                    fontSize = if (key == Key.TripleZero) 20.sp else 22.sp,
                    fontWeight = FontWeight.SemiBold,
                ).tabular(),
                color = colors.textPrimary,
            )
        }
    }
}

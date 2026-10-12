package com.djtech.monai.feature.transactions.domain.model

/**
 * How a paged list reports a failed page: Paging carries errors as throwables, so screens read
 * [error] from the load state instead of an [com.djtech.monai.core.common.result.Outcome].
 */
class TransactionLoadException(val error: TransactionError) : Exception("Loading transactions failed: $error")

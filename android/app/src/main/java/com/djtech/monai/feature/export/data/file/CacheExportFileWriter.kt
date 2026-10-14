package com.djtech.monai.feature.export.data.file

import android.content.Context
import androidx.core.content.FileProvider
import com.djtech.monai.core.common.coroutines.Dispatcher
import com.djtech.monai.core.common.coroutines.MonAIDispatcher
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.catching
import com.djtech.monai.core.common.result.getOrElse
import com.djtech.monai.feature.export.domain.file.ExportFileWriter
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.withContext
import java.io.File
import javax.inject.Inject

/**
 * Keeps one export at a time in `cache/exports/` (shared through the FileProvider): it holds
 * financial data, so earlier ones are deleted before each write.
 */
class CacheExportFileWriter @Inject constructor(
    @ApplicationContext private val context: Context,
    @Dispatcher(MonAIDispatcher.IO) private val ioDispatcher: CoroutineDispatcher,
    private val errorLogger: ErrorLogger,
) : ExportFileWriter {

    override suspend fun write(fileName: String, content: String): String? = withContext(ioDispatcher) {
        catching {
            val dir = File(context.cacheDir, EXPORTS_DIR).apply { mkdirs() }
            dir.listFiles()?.forEach(File::delete)
            val file = File(dir, fileName).apply { writeText(content, Charsets.UTF_8) }
            FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", file).toString()
        }.getOrElse { e ->
            errorLogger.log("Writing an export failed", e)
            null
        }
    }

    private companion object {
        // Matches the cache-path in res/xml/file_paths.xml.
        const val EXPORTS_DIR = "exports"
    }
}

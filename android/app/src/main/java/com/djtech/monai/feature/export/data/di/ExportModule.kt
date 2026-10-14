package com.djtech.monai.feature.export.data.di

import com.djtech.monai.feature.export.data.file.CacheExportFileWriter
import com.djtech.monai.feature.export.domain.file.ExportFileWriter
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
abstract class ExportModule {

    @Binds
    abstract fun bindExportFileWriter(writer: CacheExportFileWriter): ExportFileWriter
}

import { GetByIdInput } from './../schema/base.schema';
import { prisma } from '~/server/db/client';
import { ModelFileCreateInput as ModelFileCreateInput } from '~/server/schema/model-file.schema';
import { prepareFile } from '~/utils/file-helpers';

export const createFile = async (data: ModelFileCreateInput) => {
  const file = prepareFile(data);

  return await prisma.modelFile.create({
    data: {
      modelVersionId: data.modelVersionId,
      ...file,
    },
  });
};

// only pass data that can change (ie. modelFile.type)
// export const updateFile = async (data) => {};

export const deleteFile = async ({ id }: GetByIdInput) => {
  await prisma.modelFile.delete({ where: { id } });
};
